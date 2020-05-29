import 'dart:async';

class NumberValidator {
  final StreamTransformer<double, double> validatePositive =
      StreamTransformer<double, double>.fromHandlers(
    handleData: (value, sink) {
      if (null != value && value < 0) {
        sink.addError('Entrez un nombre positif !');
      } else {
        sink.add(value);
      }
    },
  );
}
