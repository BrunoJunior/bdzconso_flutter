import 'package:conso/database/converters/carburants_converter.dart';
import 'package:conso/database/converters/numeric_converter.dart';
import 'package:moor/moor.dart';

class Pleins extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idVehicule =>
      integer().customConstraint('REFERENCES vehicules(id)')();
  DateTimeColumn get date => dateTime()();
  TextColumn get carburant => text().map(const CarburantsConverter())();
  IntColumn get volume =>
      integer().map(NumericConverter.cents).withDefault(const Constant(0))();
  IntColumn get montant =>
      integer().map(NumericConverter.cents).withDefault(const Constant(0))();
  IntColumn get distance =>
      integer().map(NumericConverter.cents).withDefault(const Constant(0))();
  IntColumn get prixLitre =>
      integer().map(NumericConverter.milli).withDefault(const Constant(0))();
  BoolColumn get additif => boolean().withDefault(const Constant(false))();
  IntColumn get consoAffichee =>
      integer().map(NumericConverter.cents).withDefault(const Constant(0))();
  IntColumn get consoCalculee =>
      integer().map(NumericConverter.cents).withDefault(const Constant(0))();
  BoolColumn get partiel => boolean().withDefault(const Constant(false))();
  BoolColumn get traite => boolean().withDefault(const Constant(true))();
}
