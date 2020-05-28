import 'package:conso/database/converters/numeric_converter.dart';
import 'package:conso/database/database.dart';

class PleinService {
  const PleinService();

  Plein calculerPrixAuLitre(Plein plein) {
    final volume = NumericConverter.cents.mapToSql(plein.volume ?? '0');
    if (0 == volume) {
      return plein.copyWith(prixLitre: null);
    }
    final montant = NumericConverter.cents.mapToSql(plein.montant ?? '0');
    return plein.copyWith(
      prixLitre: NumericConverter.milli.getStringFromNumber(montant / volume),
    );
  }

  Plein calculerConsommation(Plein plein) {
    if (null == plein.volume || null == plein.distance) {
      return plein.copyWith(consoCalculee: null);
    }
    final distance = NumericConverter.cents.getNumberFromString(plein.distance);
    if (0.0 == distance) {
      return plein.copyWith(consoCalculee: null);
    }
    final conso = NumericConverter.cents.getNumberFromString(plein.volume) *
        100.0 /
        distance;
    return plein.copyWith(
      consoCalculee: NumericConverter.cents.getStringFromNumber(conso),
    );
  }
}
