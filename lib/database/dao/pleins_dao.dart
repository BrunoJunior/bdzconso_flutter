import 'package:conso/database/converters/numeric_converter.dart';
import 'package:conso/database/database.dart';
import 'package:conso/database/schemas/pleins.dart';
import 'package:conso/database/schemas/vehicules.dart';
import 'package:conso/services/plein_service.dart';
import 'package:moor/moor.dart';

part 'pleins_dao.g.dart';

@UseDao(tables: [Pleins, Vehicules])
class PleinsDao extends DatabaseAccessor<MyDatabase> with _$PleinsDaoMixin {
  final PleinService _pleinService = PleinService();

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

  Future<PleinsCompanion> addOne(PleinsCompanion entry) async {
    return transaction(() async {
      final id = await into(pleins).insert(
        _pleinService.calculerConsommation(entry),
      );
      final vehicule = await (select(vehicules)
            ..where((tbl) => tbl.id.equals(entry.idVehicule.value)))
          .getSingle();
      await update(vehicules).replace(
        vehicule.copyWith(
          distanceCumulee: vehicule.distanceCumulee +
              NumericConverter.cents.mapToSql(entry.distance.value),
          volumeCumule: vehicule.volumeCumule +
              NumericConverter.cents.mapToSql(entry.volume.value),
        ),
      );
      return entry.copyWith(id: Value(id));
    });
  }
}
