import 'dart:io';

import 'package:fueltter/database/converters/carburants_converter.dart';
import 'package:fueltter/database/converters/numeric_converter.dart';
import 'package:fueltter/database/dao/pleins_dao.dart';
import 'package:fueltter/database/dao/vehicules_dao.dart';
import 'package:fueltter/database/schemas/pleins.dart';
import 'package:fueltter/database/schemas/vehicules.dart';
import 'package:fueltter/models/carburant.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [Vehicules, Pleins], daos: [VehiculesDao, PleinsDao])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection());

  // Singleton instance
  static MyDatabase _singleton;
  static MyDatabase get instance {
    if (null == _singleton) {
      _singleton = MyDatabase();
    }
    return _singleton;
  }

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
