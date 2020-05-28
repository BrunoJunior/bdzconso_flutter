import 'package:conso/enums/carburants.dart';
import 'package:flutter/material.dart';

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

class CarburantChip extends StatelessWidget {
  final Carburants carburant;
  final bool selectionne;
  final VoidCallback onPressed;
  CarburantChip(this.carburant, {this.onPressed, this.selectionne = true});

  String get _libelle {
    return _mapLibellesCarburants[carburant] ?? '';
  }

  Color get _background {
    return _mapCouleursCarburants[carburant] ?? Colors.black54;
  }

  Color get _color {
    return Carburants.DIESEL == carburant ? Colors.black54 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (null == carburant) {
      return SizedBox.shrink();
    }
    if (null == onPressed) {
      return Chip(
        label: Text(_libelle),
        padding: EdgeInsets.symmetric(),
        backgroundColor: _background,
        labelStyle: TextStyle(
          color: _color,
          fontSize: 10.0,
        ),
      );
    }
    return ActionChip(
      label: Text(_libelle),
      backgroundColor: selectionne ? _background : Colors.black26,
      elevation: 4.0,
      labelStyle: TextStyle(
        color: selectionne ? _color : Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
