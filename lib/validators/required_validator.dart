import 'dart:async';

class RequiredValidator {
  final StreamTransformer<String, String> validateRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (null == value || value.isEmpty) {
      sink.addError('Champ requis !');
    } else {
      sink.add(value);
    }
  });
}
