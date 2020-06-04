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

  StreamTransformer<T, T> validateLesserThan<T extends num>(T excludedMax) =>
      StreamTransformer<T, T>.fromHandlers(
        handleData: (value, sink) {
          if (null != value && value >= excludedMax) {
            sink.addError('Entrez un nombre inférieur à $excludedMax !');
          } else {
            sink.add(value);
          }
        },
      );

  StreamTransformer<T, T> validateGreaterThan<T extends num>(T excludedMin) =>
      StreamTransformer<T, T>.fromHandlers(
        handleData: (value, sink) {
          if (null != value && value <= excludedMin) {
            sink.addError('Entrez un nombre supérieur à $excludedMin !');
          } else {
            sink.add(value);
          }
        },
      );

  StreamTransformer<T, T> validateGreaterOrEqualThan<T extends num>(T min) =>
      StreamTransformer<T, T>.fromHandlers(
        handleData: (value, sink) {
          if (null != value && value < min) {
            sink.addError('Entrez un nombre supérieur ou égale à $min !');
          } else {
            sink.add(value);
          }
        },
      );

  StreamTransformer<T, T> validateLesserOrEqualThan<T extends num>(T max) =>
      StreamTransformer<T, T>.fromHandlers(
        handleData: (value, sink) {
          if (null != value && value > max) {
            sink.addError('Entrez un nombre inférieur ou égale à $max !');
          } else {
            sink.add(value);
          }
        },
      );
}
