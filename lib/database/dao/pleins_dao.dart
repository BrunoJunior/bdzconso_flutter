import 'package:conso/database/database.dart';
import 'package:conso/database/schemas/pleins.dart';
import 'package:moor/moor.dart';

part 'pleins_dao.g.dart';

class Stats {
  final double volumeCumule;
  final double montantCumule;
  final double distanceCumulee;
  final int count;

  const Stats({
    @required this.volumeCumule,
    @required this.montantCumule,
    @required this.distanceCumulee,
    @required this.count,
  });

  const Stats.vide()
      : count = 0,
        distanceCumulee = 0,
        montantCumule = 0,
        volumeCumule = 0;

  factory Stats.fromPlein(Plein plein) {
    return Stats(
        volumeCumule: plein.volume,
        montantCumule: plein.montant,
        distanceCumulee: plein.distance,
        count: 1);
  }

  double get consoMoyenne {
    if (0 == (distanceCumulee ?? 0)) {
      return 0.0;
    }
    return 100 * (volumeCumule ?? 0) / distanceCumulee;
  }

  Stats operator +(Stats other) {
    return Stats(
      volumeCumule: (volumeCumule ?? 0.0) + (other?.volumeCumule ?? 0.0),
      montantCumule: (montantCumule ?? 0.0) + (other?.montantCumule ?? 0.0),
      distanceCumulee:
          (distanceCumulee ?? 0.0) + (other?.distanceCumulee ?? 0.0),
      count: (count ?? 0) + (other.count ?? 0),
    );
  }

  Stats operator -(Stats other) {
    return Stats(
      volumeCumule: (volumeCumule ?? 0.0) - (other?.volumeCumule ?? 0.0),
      montantCumule: (montantCumule ?? 0.0) - (other?.montantCumule ?? 0.0),
      distanceCumulee:
          (distanceCumulee ?? 0.0) - (other?.distanceCumulee ?? 0.0),
      count: (count ?? 0) - (other.count ?? 0),
    );
  }
}

@UseDao(tables: [Pleins])
class PleinsDao extends DatabaseAccessor<MyDatabase> with _$PleinsDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  PleinsDao(MyDatabase db) : super(db);

  /// Scrute tous les pleins d'un véhicule
  Stream<List<Plein>> watchAllForVehicule(int idVehicule) {
    return (select(pleins)
          ..where((tbl) => tbl.idVehicule.equals(idVehicule))
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.date,
                  mode: OrderingMode.desc,
                )
          ]))
        .watch();
  }

  /// Scrute les pleins d'un véhicule sur une année glissante (si pas de date max, c'est aujourd'hui)
  Stream<List<Plein>> watchAnneeGlissante(int idVehicule, {DateTime dateMax}) {
    final DateTime now = DateTime.now();
    if (null == dateMax || dateMax.isAfter(now)) {
      dateMax = now;
    }
    final DateTime dateMin =
        DateTime(dateMax.year - 1, dateMax.month, dateMax.day)
            .add(Duration(days: 1));
    final query = (select(pleins)
      ..where((tbl) =>
          tbl.idVehicule.equals(idVehicule) &
          tbl.traite.equals(true) &
          tbl.date.isBetweenValues(dateMin, dateMax))
      ..orderBy([(t) => OrderingTerm(expression: t.date)]));
    return query.watch();
  }

  /// Permet de réutiliser le calcul des stats
  Selectable<Stats> _getStatsQuery(Expression<bool> predicate) {
    final sumVolume = pleins.volume.sum();
    final sumDistance = pleins.distance.sum();
    final sumMontant = pleins.montant.sum();
    final count = pleins.id.count();
    final query = selectOnly(pleins)
      ..addColumns([sumVolume, sumDistance, sumMontant, count])
      ..where(predicate);
    return query.map((row) => Stats(
          volumeCumule: (row.read(sumVolume) ?? 0.0) / 100.0,
          montantCumule: (row.read(sumMontant) ?? 0.0) / 100.0,
          distanceCumulee: (row.read(sumDistance) ?? 0.0) / 100.0,
          count: row.read(count) ?? 0,
        ));
  }

  /// Scruter les stats d'un véhicule
  Stream<Stats> watchStats(int idVehicule) {
    return _getStatsQuery(pleins.idVehicule.equals(idVehicule)).watchSingle();
  }

  /// Expression permettant de récupérer les pleins partiels à traiter pour un véhiclue
  Expression<bool> Function($PleinsTable tbl) _partielsATraiter(
          int idVehicule) =>
      (tbl) => tbl.traite.equals(false) & tbl.idVehicule.equals(idVehicule);

  /// Effectue tous les calculs pour calculer la conso (suivant un plein partiel ou non)
  Future<Plein> remplirConsoCalculee(Plein nouveauPlein) async {
    // Plein partiel => conso calculée à 0
    if (nouveauPlein.partiel ?? false) {
      return nouveauPlein.copyWith(consoCalculee: 0.0);
    }
    // Expression permettant de filtrer sur les pleins partiels d'un véhicule
    final expr = _partielsATraiter(nouveauPlein.idVehicule);
    // Récupération des stats cumulées pour les partiels à traiter
    final statsPartiels = await _getStatsQuery(expr(pleins)).getSingle();
    // Conso moyenne pleins partiels + plein complet à ajouter
    // La conso calculée du nouveau plein est la conso moyenne calculée
    return nouveauPlein.copyWith(
      consoCalculee:
          (statsPartiels + Stats.fromPlein(nouveauPlein)).consoMoyenne,
    );
  }

  /// Ajouter un plein
  Future<Plein> addOne(Plein entry) => transaction(() async {
        Plein nouveauPlein = entry;
        // Si on insère un plein complet, on doit vérifier qu'il n'y a pas de partiels non traités avant
        if (!entry.partiel) {
          nouveauPlein = await remplirConsoCalculee(entry);
          // On va lisser la conso calculée de tous les pleins partiels non traités avec la conso moyenne
          // Et on précise qu'il est donc traité
          (update(pleins)..where(_partielsATraiter(nouveauPlein.idVehicule)))
              .write(
            PleinsCompanion(
              consoCalculee: Value(nouveauPlein.consoCalculee),
              traite: Value(true),
            ),
          );
        }
        // On insère ensuite le nouveau plein
        final id = await into(pleins).insert(nouveauPlein.toCompanion(true));
        return nouveauPlein.copyWith(id: id);
      });

  /// Supprimer un plein
  Future<int> deleteOne(Plein plein) {
    return (delete(pleins)..whereSamePrimaryKey(plein)).go();
  }
}
