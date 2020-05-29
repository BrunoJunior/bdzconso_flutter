import 'dart:async';

const String _doubleRule = r"^(-?\d+[.,]\d+)$|^(-?\d+)$";

class DoubleValidator {
  final StreamTransformer<String, String> validateDouble =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      if (null == value ||
          value.isEmpty ||
          !RegExp(_doubleRule).hasMatch(value)) {
        sink.addError('Entrez un nombre valide (42 / 4,2 / 4.2)');
      } else {
        sink.add(value);
      }
    },
  );
}
