import 'package:conso/database/converters/carburants_converter.dart';
import 'package:moor/moor.dart';

class Vehicules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get marque => text()();
  TextColumn get modele => text()();
  IntColumn get annee => integer().nullable()();
  IntColumn get consommation => integer().withDefault(const Constant(0))();
  IntColumn get distance => integer().withDefault(const Constant(0))();
  TextColumn get carburantsCompatibles =>
      text().map(const CarburantsListConverter()).nullable()();
  TextColumn get carburantFavoris =>
      text().map(const CarburantsConverter()).nullable()();
  BoolColumn get consoAffichee => boolean().withDefault(const Constant(true))();
}
