import 'dart:async';

class NotInFutureValidator {
  final StreamTransformer<DateTime, DateTime> validateNotInFuture =
      StreamTransformer<DateTime, DateTime>.fromHandlers(
          handleData: (value, sink) {
    if (null != value && value.isAfter(DateTime.now())) {
      sink.addError('La date ne peut être dans le futur !');
    } else {
      sink.add(value);
    }
  });
}
