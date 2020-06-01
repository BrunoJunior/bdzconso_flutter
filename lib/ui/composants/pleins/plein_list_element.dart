import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/ui/composants/carburant_chip.dart';
import 'package:fueltter/ui/composants/valeur_unite.dart';
import 'package:intl/intl.dart';

class PleinListElement extends StatelessWidget {
  final Plein plein;
  final DismissDirectionCallback onDismissed;
  const PleinListElement(this.plein, {this.onDismissed});

  static const cardPadding = 5.0;
  static const cardRadius = Radius.circular(cardPadding * 2);
  static const separateur = SizedBox(width: cardPadding * 2);

  @override
  Widget build(BuildContext context) {
    final valUniteStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );
    return Padding(
      padding: const EdgeInsets.all(cardPadding),
      child: Dismissible(
        key: Key('Plein#${plein.id}'),
        background: Padding(
          padding: const EdgeInsets.symmetric(vertical: cardPadding * 2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadiusDirectional.horizontal(end: cardRadius),
            ),
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: cardPadding * 3),
              child: FaIcon(
                FontAwesomeIcons.trash,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) => showDialog<bool>(
          context: context,
          builder: (context) =>
              plein.traite && plein.partiel ? _ImpossibleAlert() : _SureAlert(),
        ),
        onDismissed: onDismissed,
        child: Card(
          elevation: 0.0,
          margin: const EdgeInsets.all(0.0),
          shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(cardRadius),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(cardPadding),
                child: Column(
                  children: <Widget>[
                    Text(
                      DateFormat.Md().format(plein.date),
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 14.0),
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
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: cardPadding * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 25.0,
                            child: Center(
                              child: const FaIcon(FontAwesomeIcons.car),
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
                          const SizedBox(
                            width: 25.0,
                            child: const Center(
                                child: const FaIcon(FontAwesomeIcons.gasPump)),
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
        ),
      ),
    );
  }
}

class _SureAlert extends StatelessWidget {
  const _SureAlert();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Suppression'),
      content: const Text('Êtes-vous sûr de vouloir supprimer ce plein ?'),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Supprimer")),
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Annuler"),
        ),
      ],
    );
  }
}

class _ImpossibleAlert extends StatelessWidget {
  const _ImpossibleAlert();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Suppression impossible'),
      content: const Text('Ce plein partiel a été validé !'),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("OK")),
      ],
    );
  }
}
