import 'dart:math';

import 'package:moor/moor.dart';

class NumericConverter extends TypeConverter<double, int> {
  static const NumericConverter cents = NumericConverter();
  static const NumericConverter milli = NumericConverter(fractionDigits: 3);

  final int fractionDigits;
  const NumericConverter({this.fractionDigits = 2});

  num get _divider {
    return pow(10, fractionDigits);
  }

  @override
  double mapToDart(int fromDb) {
    return fromDb / _divider;
  }

  @override
  int mapToSql(double value) {
    return (value * _divider).round();
  }

  double getNumberFromString(String strNum) {
    return double.tryParse(strNum.replaceAll(',', '.')) ?? 0.0;
  }

  String getStringFromNumber(double num) {
    return num.toStringAsFixed(fractionDigits).replaceAll('.', ',');
  }
}
