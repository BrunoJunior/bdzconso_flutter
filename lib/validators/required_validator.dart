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

  StreamTransformer<T, T> validateNotNull<T>() =>
      StreamTransformer<T, T>.fromHandlers(handleData: (value, sink) {
        if (null == value) {
          sink.addError('Champ requis !');
        } else {
          sink.add(value);
        }
      });

  StreamTransformer<List<T>, List<T>> validateRequiredArray<T>() =>
      StreamTransformer<List<T>, List<T>>.fromHandlers(
          handleData: (value, sink) {
        if (null == value || value.isEmpty) {
          sink.addError('Merci de fournir au moins une valeur !');
        } else {
          sink.add(value);
        }
      });
}
