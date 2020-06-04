import 'dart:convert';

import 'package:fueltter/enums/carburants.dart';
import 'package:moor/moor.dart';

const Map<Carburant, String> _mapCarburants = {
  Carburant.DIESEL: 'diesel',
  Carburant.E85: 'e85',
  Carburant.GPL: 'gpl',
  Carburant.SP95_E10: 'e10',
  Carburant.SP95: 'sp95',
  Carburant.SP98: 'sp98',
};

class CarburantsConverter extends TypeConverter<Carburant, String> {
  static Map<String, Carburant> _reversedMap = Map.fromEntries(
    _mapCarburants.entries.map(
      (entry) => MapEntry(entry.value, entry.key),
    ),
  );
  const CarburantsConverter();

  @override
  Carburant mapToDart(String fromDb) {
    if (fromDb == null || !_reversedMap.containsKey(fromDb)) {
      return null;
    }
    return _reversedMap[fromDb];
  }

  @override
  String mapToSql(Carburant value) {
    return value != null ? _mapCarburants[value] : null;
  }
}

class CarburantsListConverter extends TypeConverter<List<Carburant>, String> {
  final CarburantsConverter elementConverter = const CarburantsConverter();
  const CarburantsListConverter();

  @override
  List<Carburant> mapToDart(String fromDb) {
    if (fromDb == null) {
      return [];
    }
    List decoded = json.decode(fromDb);
    return decoded
        .map((el) => elementConverter.mapToDart(el.toString()))
        .toList();
  }

  @override
  String mapToSql(List<Carburant> values) {
    return json.encode(values?.map(elementConverter.mapToSql)?.toList() ?? []);
  }
}
