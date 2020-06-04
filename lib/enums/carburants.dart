import 'package:flutter/material.dart';

enum Carburant { SP95, SP98, SP95_E10, DIESEL, GPL, E85 }

const Map<Carburant, String> _mapLibellesCarburants = {
  Carburant.SP95: 'SP95',
  Carburant.SP98: 'SP98',
  Carburant.SP95_E10: 'SP95-E10',
  Carburant.DIESEL: 'Diesel',
  Carburant.GPL: 'GPL',
  Carburant.E85: 'E85',
};

const Map<Carburant, Color> _mapCouleursCarburants = {
  Carburant.SP95: Colors.green,
  Carburant.SP98: Colors.green,
  Carburant.SP95_E10: Colors.green,
  Carburant.DIESEL: Colors.yellow,
  Carburant.GPL: Colors.red,
  Carburant.E85: Colors.blue,
};

class CarburantDisplayer {
  final Carburant carburant;

  const CarburantDisplayer(this.carburant);

  String get libelle {
    return _mapLibellesCarburants[carburant] ?? '';
  }

  Color get background {
    return _mapCouleursCarburants[carburant] ?? Colors.black54;
  }

  Color get color {
    return Carburant.DIESEL == carburant ? Colors.black54 : Colors.white;
  }
}
