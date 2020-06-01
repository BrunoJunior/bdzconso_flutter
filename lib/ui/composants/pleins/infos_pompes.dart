import 'package:flutter/material.dart';
import 'package:fueltter/blocs/add_plein_form_bloc.dart';
import 'package:fueltter/blocs/bloc_provider.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/enums/carburants.dart';
import 'package:fueltter/transformers/double_transformer.dart';
import 'package:fueltter/ui/composants/carburant_chip.dart';
import 'package:fueltter/ui/composants/form_card.dart';
import 'package:fueltter/ui/composants/pleins/focus_changer.dart';

class InfosPompe extends StatelessWidget with DoubleTransformer, FocusChanger {
  final Vehicule vehicule;
  final FocusNode firstFocusNode;
  final ValueChanged<String> onSubmit;
  final bool autofocus;
  final FocusNode _prixFocus = FocusNode();
  final FocusNode _volumeFocus = FocusNode();

  InfosPompe(this.vehicule,
      {this.firstFocusNode, this.onSubmit, this.autofocus = false});

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<AddPleinFormBloc>(context);
    return FormCard(
      title: 'Infos pompe',
      titleIcon: const Icon(Icons.local_gas_station),
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
              title: const Text('Additivé'),
              value: snapshot.data ?? false,
              onChanged: formBloc.onAdditiveChanged,
            );
          },
        ),
        StreamBuilder<double>(
          stream: formBloc.prix,
          builder: (context, snapshot) {
            return TextField(
              focusNode: firstFocusNode ?? _prixFocus,
              autofocus: autofocus,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) => fieldFocusChange(
                  context, firstFocusNode ?? _prixFocus, _volumeFocus),
              decoration: InputDecoration(
                labelText: 'Prix *',
                suffix: const Text('€'),
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
              focusNode: _volumeFocus,
              onSubmitted: (value) {
                _volumeFocus.unfocus();
                if (null != onSubmit) {
                  onSubmit(value);
                }
              },
              decoration: InputDecoration(
                labelText: 'Volume *',
                suffix: const Text('L'),
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
              title: const Text("Je n'ai pas fait le plein"),
              value: snapshot.data ?? false,
              onChanged: formBloc.onPartielChanged,
            );
          },
        ),
      ],
    );
  }
}
