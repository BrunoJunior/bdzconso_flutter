import 'dart:async';

class DoubleTransformer {
  final StreamTransformer<String, double> stringToDouble =
      StreamTransformer<String, double>.fromHandlers(
    handleData: (value, sink) {
      if (null == value) {
        sink.add(null);
      }
      try {
        sink.add(double.parse(value.replaceAll(',', '.')));
      } catch (e) {
        sink.addError('Format de nombre incorrect !');
      }
    },
  );
  StreamTransformer<double, String> doubleToString({int fractionDigits = 2}) =>
      StreamTransformer<double, String>.fromHandlers(
        handleData: (value, sink) {
          if (null == value) {
            sink.add(null);
          } else {
            sink.add(value.toStringAsFixed(fractionDigits));
          }
        },
      );
}
