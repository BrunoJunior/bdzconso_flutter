import 'package:flutter/material.dart';

class ValeurUnite extends StatelessWidget {
  final String unite;
  final double valeur;
  final int nbDecimales;
  final TextStyle textStyle;
  ValeurUnite(
      {@required this.unite,
      @required this.valeur,
      this.nbDecimales = 2,
      this.textStyle = const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
      )});
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: valeur?.toStringAsFixed(nbDecimales)?.replaceAll('.', ',') ??
              '--',
          style: textStyle,
          children: [
            TextSpan(
                text: ' $unite',
                style: TextStyle(
                    fontSize: textStyle.fontSize * 2.0 / 3.0,
                    fontWeight: FontWeight.normal))
          ]),
    );
  }
}
