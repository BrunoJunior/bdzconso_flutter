import 'package:conso/database/converters/numeric_converter.dart';
import 'package:conso/database/database.dart';
import 'package:moor/moor.dart' show Value;

class PleinService {
  const PleinService();

  PleinsCompanion calculerPrixAuLitre(PleinsCompanion plein) {
    final volume = NumericConverter.cents.mapToSql(plein.volume.value ?? '0');
    if (0 == volume) {
      return plein.copyWith(prixLitre: Value.absent());
    }
    final montant = NumericConverter.cents.mapToSql(plein.montant.value ?? '0');
    return plein.copyWith(
      prixLitre:
          Value(NumericConverter.milli.getStringFromNumber(montant / volume)),
    );
  }

  PleinsCompanion calculerConsommation(PleinsCompanion plein) {
    if (!plein.volume.present || !plein.distance.present) {
      return plein.copyWith(consoCalculee: Value.absent());
    }
    final distance =
        NumericConverter.cents.getNumberFromString(plein.distance.value);
    if (0.0 == distance) {
      return plein.copyWith(consoCalculee: Value.absent());
    }
    final conso =
        NumericConverter.cents.getNumberFromString(plein.volume.value) *
            100.0 /
            distance;
    return plein.copyWith(
      consoCalculee: Value(NumericConverter.cents.getStringFromNumber(conso)),
    );
  }
}
