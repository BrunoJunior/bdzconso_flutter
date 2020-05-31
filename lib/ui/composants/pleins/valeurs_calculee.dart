import 'package:conso/blocs/add_plein_form_bloc.dart';
import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/database/converters/numeric_converter.dart';
import 'package:conso/ui/composants/form_card.dart';
import 'package:conso/ui/composants/valeur_unite.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';

class ValeursCalculees extends StatelessWidget {
  const ValeursCalculees();

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<AddPleinFormBloc>(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StreamBuilder<bool>(
            stream: formBloc.partiel,
            builder: (context, snapshot) {
              if (snapshot.data ?? false) {
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
                          StreamBuilder<double>(
                              stream: formBloc.consoCalculee,
                              builder: (context, snapshot) {
                                return ValeurUnite(
                                  unite: 'l/100km',
                                  valeur: snapshot.data,
                                );
                              }),
                          StreamBuilder<double>(
                              stream: CombineLatestStream.combine2(
                                formBloc.consoCalculee,
                                formBloc.consoAffichee,
                                (double calc, double aff) => calc - aff,
                              ),
                              builder: (context, snapshot) {
                                final diff = snapshot.data ?? 0.0;
                                return Visibility(
                                  visible: diff != 0,
                                  child: Text(
                                    ' (${diff > 0 ? '+' : ''}${NumericConverter.cents.getStringFromNumber(diff)})',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  ),
                                );
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
        Expanded(
          child: FormCard(title: 'Prix au litre', children: [
            StreamBuilder<double>(
              stream: formBloc.prixLitre,
              builder: (context, snapshot) => ValeurUnite(
                unite: '€/L',
                valeur: snapshot.data,
                nbDecimales: 3,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
