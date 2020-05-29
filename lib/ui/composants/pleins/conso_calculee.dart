import 'package:conso/blocs/add_plein_form_bloc.dart';
import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/database/converters/numeric_converter.dart';
import 'package:conso/ui/composants/form_card.dart';
import 'package:conso/ui/composants/valeur_unite.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';

class _InfosConso {
  final double calculee;
  final double affichee;
  _InfosConso(this.calculee, this.affichee);

  get difference => calculee - affichee;
}

class ConsoCalculee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<AddPleinFormBloc>(context);
    return StreamBuilder<_InfosConso>(
        stream: CombineLatestStream.combine2(formBloc.consoCalculee,
            formBloc.consoAffichee, (a, b) => _InfosConso(a, b)),
        builder: (context, snapshot) {
          final diff = snapshot.data?.difference ?? 0.0;
          return FormCard(
            title: 'Consommation calculée',
            titleIcon: Icon(Icons.data_usage),
            children: [
              ValeurUnite(
                unite: 'l/100km',
                valeur: snapshot.data?.calculee,
              ),
              Visibility(
                visible: diff != 0,
                child: Text(
                  '${diff > 0 ? '+' : ''}${NumericConverter.cents.getStringFromNumber(diff)}',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          );
        });
  }
}
