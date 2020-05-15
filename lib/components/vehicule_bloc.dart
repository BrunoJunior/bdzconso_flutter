import 'package:conso/components/valeur_unite.dart';
import 'package:flutter/material.dart';

class VehiculeBloc extends StatelessWidget {
  final String marque, modele;
  final int annee;
  final double distance, consommation;

  VehiculeBloc(
      {@required this.marque,
      @required this.modele,
      this.annee,
      this.distance = 0.0,
      this.consommation = 0.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding:
              EdgeInsets.only(right: 5.0, left: 50.0, top: 5.0, bottom: 5.0),
          child: Material(
            color: Color(0xFF212121),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.only(
                left: 50.0,
                right: 20.0,
                top: 10.0,
                bottom: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$marque $modele',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    annee.toString(),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ValeurUnite(
                        unite: 'km',
                        valeur: distance,
                      ),
                      ValeurUnite(
                        unite: 'l/100km',
                        valeur: consommation,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0, left: 5.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFF212121),
            radius: 45.0,
            child: Icon(Icons.photo_camera),
          ),
        ),
      ],
    );
  }
}
