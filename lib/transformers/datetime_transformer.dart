import 'dart:async';

import 'package:intl/intl.dart';

class DateTimeTransformer {
  StreamTransformer<String, DateTime> stringToDateTime(DateFormat format) =>
      StreamTransformer<String, DateTime>.fromHandlers(
        handleData: (value, sink) {
          if (null == value) {
            sink.add(null);
          }
          try {
            sink.add(format.parse(value));
          } catch (e) {
            sink.addError('Format de date incorrect !');
          }
        },
      );
  StreamTransformer<DateTime, String> dateTimeToString(DateFormat format) =>
      StreamTransformer<DateTime, String>.fromHandlers(
        handleData: (value, sink) {
          if (null == value) {
            sink.add(null);
          } else {
            sink.add(format.format(value));
          }
        },
      );
}
