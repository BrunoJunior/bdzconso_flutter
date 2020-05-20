import 'package:conso/database/database.dart';
import 'package:conso/database/schemas/vehicules.dart';
import 'package:moor/moor.dart';

part 'vehicules_dao.g.dart';

// the _TodosDaoMixin will be created by moor. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@UseDao(tables: [Vehicules])
class VehiculesDao extends DatabaseAccessor<MyDatabase>
    with _$VehiculesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  VehiculesDao(MyDatabase db) : super(db);

  Stream<List<Vehicule>> watchAll() {
    return select(vehicules).watch();
  }

  Future<int> addOne(VehiculesCompanion entry) {
    return into(vehicules).insert(entry);
  }
}
