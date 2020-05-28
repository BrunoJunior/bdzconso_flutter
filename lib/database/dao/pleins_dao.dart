import 'package:conso/database/database.dart';
import 'package:conso/database/schemas/pleins.dart';
import 'package:moor/moor.dart';

part 'pleins_dao.g.dart';

class Stats {
  final int volumeCumule;
  final int montantCumule;
  final int distanceCumulee;
  final int count;

  const Stats({
    @required this.volumeCumule,
    @required this.montantCumule,
    @required this.distanceCumulee,
    @required this.count,
  });

  double get consoMoyenne {
    return 100 * (volumeCumule ?? 0) / (distanceCumulee ?? 1);
  }
}

@UseDao(tables: [Pleins])
class PleinsDao extends DatabaseAccessor<MyDatabase> with _$PleinsDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  PleinsDao(MyDatabase db) : super(db);

  Stream<List<Plein>> watchAll() {
    return select(pleins).watch();
  }

  Stream<List<Plein>> watchAllForVehicule(int idVehicule) {
    return (select(pleins)..where((tbl) => tbl.idVehicule.equals(idVehicule)))
        .watch();
  }

  Stream<List<Plein>> watchAnneeGlissante(int idVehicule, {DateTime dateMax}) {
    final DateTime now = DateTime.now();
    if (null == dateMax || dateMax.isAfter(now)) {
      dateMax = now;
    }
    final DateTime dateMin =
        DateTime(dateMax.year - 1, dateMax.month, dateMax.day)
            .add(Duration(days: 1));
    return (select(pleins)
          ..where((tbl) => tbl.idVehicule.equals(idVehicule))
          ..where((tbl) => tbl.date.isBetweenValues(dateMin, dateMax))
          ..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .watch();
  }

  Stream<Stats> watchStats(int idVehicule) {
    final sumVolume = pleins.volume.sum();
    final sumDistance = pleins.distance.sum();
    final sumMontant = pleins.montant.sum();
    final count = pleins.id.count();
    final query = selectOnly(pleins)
      ..addColumns([sumVolume, sumDistance, sumMontant, count])
      ..where(pleins.idVehicule.equals(idVehicule));
    return query
        .map((row) => Stats(
              volumeCumule: row.read(sumVolume),
              montantCumule: row.read(sumMontant),
              distanceCumulee: row.read(sumDistance),
              count: row.read(count),
            ))
        .watchSingle();
  }

  Future<PleinsCompanion> addOne(PleinsCompanion entry) async {
    final id = await into(pleins).insert(entry);
    return entry.copyWith(id: Value(id));
  }

  Future<int> deleteOne(Plein plein) {
    return (delete(pleins)..whereSamePrimaryKey(plein)).go();
  }
}
