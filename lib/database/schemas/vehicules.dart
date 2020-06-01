import 'package:fueltter/database/converters/carburants_converter.dart';
import 'package:moor/moor.dart';

class Vehicules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get marque => text()();
  TextColumn get modele => text()();
  IntColumn get annee => integer().nullable()();
  TextColumn get carburantsCompatibles =>
      text().map(const CarburantsListConverter()).nullable()();
  TextColumn get carburantFavoris =>
      text().map(const CarburantsConverter()).nullable()();
  BoolColumn get consoAffichee => boolean().withDefault(const Constant(true))();
  TextColumn get photo => text().nullable()();
}
