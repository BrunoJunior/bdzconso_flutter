import 'package:flutter/material.dart';
import 'package:fueltter/database/converters/numeric_converter.dart';
import 'package:fueltter/forms/form_validators.dart';
import 'package:fueltter/forms/plein_form.dart';
import 'package:fueltter/ui/composants/form_card.dart';
import 'package:fueltter/ui/composants/valeur_unite.dart';
import 'package:provider/provider.dart';

class ValeursCalculees extends StatelessWidget {
  const ValeursCalculees();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Selector<PleinForm, bool>(
          selector: (_, form) => form.partiel.value ?? false,
          builder: (_, partiel, __) {
            if (partiel) {
              return const SizedBox.shrink();
            }
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: FormCard(
                  title: 'Consommation',
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Selector<PleinForm, double>(
                          selector: (_, form) => form.consoCalculee,
                          builder: (_, consoCalculee, __) => ValeurUnite(
                            unite: 'l/100km',
                            valeur: consoCalculee,
                          ),
                        ),
                        Selector<PleinForm, double>(
                          selector: (_, form) =>
                              (form.consoCalculee ?? 0.0) -
                              (DoubleValidator.parse(
                                      form.consoAffichee.value) ??
                                  0.0),
                          builder: (_, diff, __) => Visibility(
                            visible: diff != 0,
                            child: Text(
                              ' (${diff > 0 ? '+' : ''}${NumericConverter.cents.getStringFromNumber(diff)})',
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: FormCard(title: 'Prix au litre', children: [
            Selector<PleinForm, double>(
              selector: (_, form) => form.prixLitre,
              builder: (_, prix, __) => ValeurUnite(
                unite: '€/L',
                valeur: prix,
                nbDecimales: 3,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
