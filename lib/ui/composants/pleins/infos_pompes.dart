import 'package:conso/blocs/add_plein_form_bloc.dart';
import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/database/database.dart';
import 'package:conso/enums/carburants.dart';
import 'package:conso/transformers/double_transformer.dart';
import 'package:conso/ui/composants/carburant_chip.dart';
import 'package:conso/ui/composants/form_card.dart';
import 'package:flutter/material.dart';

class InfosPompe extends StatelessWidget with DoubleTransformer {
  final Vehicule vehicule;
  InfosPompe(this.vehicule);

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<AddPleinFormBloc>(context);
    return FormCard(
      title: 'Infos pompe',
      titleIcon: Icon(Icons.local_gas_station),
      children: [
        StreamBuilder<Carburants>(
          stream: formBloc.carburant,
          builder: (context, snapshot) {
            return Wrap(
              spacing: 8.0,
              alignment: WrapAlignment.center,
              children: vehicule.carburantsCompatibles
                  .map(
                    (carburant) => CarburantChip(
                      carburant,
                      selectionne: carburant == snapshot.data,
                      onPressed: () => formBloc.onCarburantChanged(carburant),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        StreamBuilder<bool>(
          stream: formBloc.additive,
          builder: (context, snapshot) {
            return SwitchListTile(
              title: Text('Additivé'),
              value: snapshot.data ?? false,
              onChanged: formBloc.onAdditiveChanged,
            );
          },
        ),
        StreamBuilder<double>(
          stream: formBloc.prix,
          builder: (context, snapshot) {
            return TextField(
              decoration: InputDecoration(
                labelText: 'Prix *',
                suffix: Text('€'),
                errorText: snapshot.error,
              ),
              keyboardType: TextInputType.number,
              onChanged: formBloc.onPrixChanged,
            );
          },
        ),
        StreamBuilder<double>(
          stream: formBloc.volume,
          builder: (context, snapshot) {
            return TextField(
              decoration: InputDecoration(
                labelText: 'Volume *',
                suffix: Text('L'),
                errorText: snapshot.error,
              ),
              keyboardType: TextInputType.number,
              onChanged: formBloc.onVolumeChanged,
            );
          },
        ),
        StreamBuilder<bool>(
          stream: formBloc.partiel,
          builder: (context, snapshot) {
            return SwitchListTile(
              title: Text("Je n'ai pas fait le plein"),
              value: snapshot.data ?? false,
              onChanged: formBloc.onPartielChanged,
            );
          },
        ),
      ],
    );
  }
}
