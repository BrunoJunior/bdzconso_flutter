import 'package:fueltter/database/database.dart';
import 'package:fueltter/database/schemas/pleins.dart';
import 'package:fueltter/models/stats.dart';
import 'package:intl/intl.dart';
import 'package:moor/moor.dart';

part 'pleins_dao.g.dart';

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
        Plein nouveauPlein =
            entry.partiel ? entry : await remplirConsoCalculee(entry);
        // On insère le nouveau plein
        final id = await into(pleins).insert(nouveauPlein.toCompanion(true));
        // Si on insère un plein complet, on doit vérifier qu'il n'y a pas de partiels non traités
        if (!entry.partiel) {
          // On va lisser la conso calculée de tous les pleins partiels non traités avec la conso moyenne
          // Et on précise qu'il est donc traité
          (update(pleins)..where(_partielsATraiter(nouveauPlein.idVehicule)))
              .write(
            PleinsCompanion(
              consoCalculee: Value(nouveauPlein.consoCalculee),
              traite: Value(true),
              // On rattache le plein complet utilisé pour compléter les partiels précédents
              validateur: Value(id),
            ),
          );
        }
        return nouveauPlein.copyWith(id: id);
      });

  /// Supprimer un plein
  Future<Plein> deleteOne(Plein plein) async {
    final isPartiel = plein.partiel ?? false;
    final isTraite = plein.traite ?? false;
    // On ne peut supprimer un plein partiel validé
    if (isPartiel && isTraite) {
      final validateur = await (select(pleins)
            ..where((tbl) => tbl.id.equals(plein.validateur)))
          .getSingle();
      throw Exception(
          'Ce plein partiel a été validé par le plein du ${DateFormat.yMd().format(validateur.date)} ! Veuillez supprimer ce dernier en premier lieu !');
    }
    return await transaction(() async {
      // Lors de la suppression d'un plein validant un/des partiels
      // On invalide les partiels liés
      if (!isPartiel) {
        await (update(pleins)
              ..where((tbl) =>
                  tbl.idVehicule.equals(plein.idVehicule) &
                  tbl.validateur.equals(plein.id)))
            .write(
          PleinsCompanion(
            validateur: Value(null),
            traite: Value(false),
            consoCalculee: Value(0.0),
          ),
        );
      }
      // Puis on supprime le plein
      return (delete(pleins)..whereSamePrimaryKey(plein))
          .go()
          .then((v) => plein);
    });
  }
}
