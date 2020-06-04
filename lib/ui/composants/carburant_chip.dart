import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fueltter/enums/carburants.dart';

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

class CarburantChip extends StatelessWidget {
  final Carburant carburant;
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
    return Carburant.DIESEL == carburant ? Colors.black54 : Colors.white;
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
