import 'dart:convert';

import 'package:conso/enums/carburants.dart';
import 'package:moor/moor.dart';

const Map<Carburants, String> _mapCarburants = {
  Carburants.DIESEL: 'diesel',
  Carburants.E85: 'e85',
  Carburants.GPL: 'gpl',
  Carburants.SP95_E10: 'e10',
  Carburants.SP95: 'sp95',
  Carburants.SP98: 'sp98',
};

class CarburantsConverter extends TypeConverter<Carburants, String> {
  static Map<String, Carburants> _reversedMap = Map.fromEntries(
    _mapCarburants.entries.map(
      (entry) => MapEntry(entry.value, entry.key),
    ),
  );
  const CarburantsConverter();

  @override
  Carburants mapToDart(String fromDb) {
    if (fromDb == null || !_reversedMap.containsKey(fromDb)) {
      return null;
    }
    return _reversedMap[fromDb];
  }

  @override
  String mapToSql(Carburants value) {
    return value != null ? _mapCarburants[value] : null;
  }
}

class CarburantsListConverter extends TypeConverter<List<Carburants>, String> {
  final CarburantsConverter elementConverter = const CarburantsConverter();
  const CarburantsListConverter();

  @override
  List<Carburants> mapToDart(String fromDb) {
    if (fromDb == null) {
      return [];
    }
    List decoded = json.decode(fromDb);
    return decoded
        .map((el) => elementConverter.mapToDart(el.toString()))
        .toList();
  }

  @override
  String mapToSql(List<Carburants> values) {
    return json.encode(values?.map(elementConverter.mapToSql)?.toList() ?? []);
  }
}
