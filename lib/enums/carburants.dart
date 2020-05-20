import 'package:flutter/material.dart';

enum Carburants { SP95, SP98, SP95_E10, DIESEL, GPL, E85 }

const Map<Carburants, String> _mapLibellesCarburants = {
  Carburants.SP95: 'SP95',
  Carburants.SP98: 'SP98',
  Carburants.SP95_E10: 'SP95-E10',
  Carburants.DIESEL: 'Diesel',
  Carburants.GPL: 'GPL',
  Carburants.E85: 'E85',
};

const Map<Carburants, Color> _mapCouleursCarburants = {
  Carburants.SP95: Colors.green,
  Carburants.SP98: Colors.green,
  Carburants.SP95_E10: Colors.green,
  Carburants.DIESEL: Colors.yellow,
  Carburants.GPL: Colors.red,
  Carburants.E85: Colors.blue,
};

class CarburantDisplayer {
  final Carburants carburant;

  const CarburantDisplayer(this.carburant);

  String get libelle {
    return _mapLibellesCarburants[carburant] ?? '';
  }

  Color get background {
    return _mapCouleursCarburants[carburant] ?? Colors.black54;
  }

  Color get color {
    return Carburants.DIESEL == carburant ? Colors.black54 : Colors.white;
  }
}
