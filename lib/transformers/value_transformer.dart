import 'dart:async';

import 'package:moor/moor.dart' show Value;

class ValueTransformer {
  StreamTransformer<T, Value<T>> dataToValue<T>() =>
      StreamTransformer<T, Value<T>>.fromHandlers(
        handleData: (value, sink) {
          sink.add(Value(value));
        },
      );
}
