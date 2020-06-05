import 'package:flutter/material.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/forms/form_element.dart';
import 'package:fueltter/forms/plein_form.dart';
import 'package:fueltter/models/carburant.dart';
import 'package:fueltter/ui/composants/carburant_chip.dart';
import 'package:fueltter/ui/composants/form_card.dart';
import 'package:fueltter/ui/composants/pleins/focus_changer.dart';
import 'package:provider/provider.dart';

class InfosPompe extends StatelessWidget with FocusChanger {
  final FocusNode firstFocusNode;
  final ValueChanged<String> onSubmit;
  final bool autofocus;
  final FocusNode _prixFocus = FocusNode();
  final FocusNode _volumeFocus = FocusNode();

  InfosPompe({this.firstFocusNode, this.onSubmit, this.autofocus = false});

  @override
  Widget build(BuildContext context) {
    return FormCard(
      title: 'Infos pompe',
      titleIcon: const Icon(Icons.local_gas_station),
      children: [
        Selector<PleinForm, Vehicule>(
          selector: (_, form) => form.vehicule,
          builder: (_, vehicule, __) =>
              Selector<PleinForm, FormElement<PleinField, Carburant>>(
            selector: (_, form) => form.carburant,
            builder: (_, selected, __) => Wrap(
              spacing: 8.0,
              alignment: WrapAlignment.center,
              children: vehicule.carburantsCompatibles
                  .map(
                    (carburant) => CarburantChip(
                      carburant,
                      selectionne: carburant == selected.value,
                      onPressed: () => selected.change(carburant),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Selector<PleinForm, FormElement<PleinField, bool>>(
          selector: (_, form) => form.additif,
          builder: (_, additif, __) => SwitchListTile(
            title: const Text('Additivé'),
            value: additif.value ?? false,
            onChanged: additif.change,
          ),
        ),
        Selector<PleinForm, FormElement<PleinField, String>>(
          selector: (_, form) => form.montant,
          builder: (context, prix, __) => TextField(
            focusNode: firstFocusNode ?? _prixFocus,
            autofocus: autofocus,
            textInputAction: TextInputAction.next,
            onSubmitted: (value) => fieldFocusChange(
                context, firstFocusNode ?? _prixFocus, _volumeFocus),
            decoration: InputDecoration(
              labelText: 'Prix *',
              suffix: const Text('€'),
              errorText: prix.error,
            ),
            keyboardType: TextInputType.number,
            onChanged: prix.change,
          ),
        ),
        Selector<PleinForm, FormElement<PleinField, String>>(
          selector: (_, form) => form.volume,
          builder: (context, volume, __) => TextField(
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
              errorText: volume.error,
            ),
            keyboardType: TextInputType.number,
            onChanged: volume.change,
          ),
        ),
        Selector<PleinForm, FormElement<PleinField, bool>>(
          selector: (_, form) => form.partiel,
          builder: (_, partiel, __) => SwitchListTile(
            title: const Text("Je n'ai pas fait le plein"),
            value: partiel.value ?? false,
            onChanged: partiel.change,
          ),
        ),
      ],
    );
  }
}
