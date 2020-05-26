import 'package:flutter/material.dart';

class ValeurUnite extends StatelessWidget {
  final String unite;
  final double valeur;
  final int nbDecimales;
  ValeurUnite(
      {@required this.unite, @required this.valeur, this.nbDecimales = 2});
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: valeur?.toStringAsFixed(nbDecimales)?.replaceAll('.', ',') ??
              '--',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
          children: [
            TextSpan(
                text: ' $unite',
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal))
          ]),
    );
  }
}
