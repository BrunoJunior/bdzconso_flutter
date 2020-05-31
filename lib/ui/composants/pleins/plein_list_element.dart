import 'package:conso/database/database.dart';
import 'package:conso/ui/composants/carburant_chip.dart';
import 'package:conso/ui/composants/valeur_unite.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PleinListElement extends StatelessWidget {
  final Plein plein;
  const PleinListElement(this.plein);

  @override
  Widget build(BuildContext context) {
    final valUniteStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );
    final separateur = const SizedBox(width: 10.0);
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Text(
                  DateFormat.Md().format(plein.date),
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
                ),
                SizedBox(height: 5.0),
                Container(
                  decoration: BoxDecoration(
                    border: BorderDirectional(
                      top: BorderSide(
                          width: 2.0,
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                  ),
                  child: Text(
                    DateFormat.y().format(plein.date),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: BorderDirectional(
                  start: BorderSide(
                      width: 2.0,
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 25.0,
                        child: Center(
                          child: FaIcon(FontAwesomeIcons.car),
                        ),
                      ),
                      separateur,
                      ValeurUnite(
                        unite: 'km',
                        valeur: plein.distance,
                        textStyle: valUniteStyle,
                      ),
                      separateur,
                      ValeurUnite(
                        unite: 'L/100km',
                        valeur: plein.consoAffichee,
                        textStyle: valUniteStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 25.0,
                        child: Center(child: FaIcon(FontAwesomeIcons.gasPump)),
                      ),
                      separateur,
                      ValeurUnite(
                        unite: 'L',
                        valeur: plein.volume,
                        textStyle: valUniteStyle,
                      ),
                      separateur,
                      ValeurUnite(
                        unite: '€',
                        valeur: plein.montant,
                        textStyle: valUniteStyle,
                      ),
                      separateur,
                      ValeurUnite(
                        unite: '€/L',
                        valeur: plein.prixLitre,
                        textStyle: valUniteStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 25.0,
                        child: Center(
                          child: FaIcon(
                            plein.partiel
                                ? FontAwesomeIcons.thermometerHalf
                                : FontAwesomeIcons.thermometerFull,
                            color: plein.traite
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                        ),
                      ),
                      separateur,
                      CarburantChip(
                        plein.carburant,
                        additive: plein.additif,
                      ),
                      separateur,
                      ValeurUnite(
                        unite: 'L/100km',
                        valeur: 0 == plein.consoCalculee
                            ? null
                            : plein.consoCalculee,
                        textStyle: valUniteStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
