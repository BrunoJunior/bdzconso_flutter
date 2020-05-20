import 'package:conso/components/valeur_unite.dart';
import 'package:conso/database/database.dart';
import 'package:conso/enums/carburants.dart';
import 'package:flutter/material.dart';

class VehiculeBloc extends StatelessWidget {
  final Vehicule vehicule;

  VehiculeBloc(this.vehicule);

  Widget _getFavoris() {
    if (vehicule.carburantFavoris == null) {
      return Container();
    }
    CarburantDisplayer displayer =
        CarburantDisplayer(vehicule.carburantFavoris);
    return Chip(
      label: Text(displayer.libelle),
      padding: EdgeInsets.symmetric(),
      backgroundColor: displayer.background,
      labelStyle: TextStyle(
        color: displayer.color,
        fontSize: 12.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
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
                    '${vehicule.marque} ${vehicule.modele}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    vehicule.annee?.toString() ?? '',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _getFavoris(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ValeurUnite(
                            unite: 'km',
                            valeur: (vehicule.distance ?? 0) / 100.0,
                          ),
                          ValeurUnite(
                            unite: 'l/100km',
                            valeur: (vehicule.consommation ?? 0) / 100.0,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0),
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
