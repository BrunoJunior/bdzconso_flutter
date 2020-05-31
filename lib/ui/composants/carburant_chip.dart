import 'package:conso/enums/carburants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final bool additive;
  const CarburantChip(this.carburant,
      {this.onPressed, this.selectionne = true, this.additive = false});

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
        label: _ChipText(_libelle, additive: additive),
        padding: EdgeInsets.symmetric(),
        backgroundColor: _background,
        labelStyle: TextStyle(
          color: _color,
          fontSize: 10.0,
        ),
      );
    }
    return ActionChip(
      label: _ChipText(_libelle, additive: additive),
      backgroundColor:
          selectionne ? _background : Theme.of(context).scaffoldBackgroundColor,
      elevation: 4.0,
      labelStyle: TextStyle(
        color: selectionne ? _color : Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}

class _ChipText extends StatelessWidget {
  final String libelle;
  final bool additive;
  const _ChipText(this.libelle, {this.additive});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(libelle),
        Visibility(
          visible: additive,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: FaIcon(
              FontAwesomeIcons.plus,
              size: 15.0,
            ),
          ),
        )
      ],
    );
  }
}
