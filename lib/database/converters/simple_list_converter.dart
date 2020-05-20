import 'dart:convert';

import 'package:moor/moor.dart';

class SimpleListConverter<T> extends TypeConverter<List<T>, String> {
  const SimpleListConverter();
  @override
  List<T> mapToDart(String fromDb) {
    if (fromDb == null) {
      return [];
    }
    return json.decode(fromDb);
  }

  @override
  String mapToSql(List<T> value) {
    return json.encode(value ?? []);
  }
}
