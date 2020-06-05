import 'package:flutter/material.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/forms/form_element.dart';
import 'package:fueltter/forms/plein_form.dart';
import 'package:fueltter/ui/composants/form_card.dart';
import 'package:fueltter/ui/composants/pleins/focus_changer.dart';
import 'package:provider/provider.dart';

class InfosVehicule extends StatelessWidget with FocusChanger {
  final FocusNode firstFocusNode;
  final ValueChanged<String> onSubmit;
  final bool autofocus;
  final FocusNode _distanceFocus = FocusNode();
  final FocusNode _consoFocus = FocusNode();

  InfosVehicule({this.firstFocusNode, this.onSubmit, this.autofocus = false});

  @override
  Widget build(BuildContext context) {
    return FormCard(
      title: 'Infos véhicule',
      titleIcon: const Icon(Icons.directions_car),
      children: [
        Selector<PleinForm, FormElement<PleinField, String>>(
          selector: (_, form) => form.distance,
          builder: (context, distance, _) => TextField(
            focusNode: firstFocusNode ?? _distanceFocus,
            autofocus: autofocus,
            textInputAction: TextInputAction.next,
            onSubmitted: (value) => fieldFocusChange(
                context, firstFocusNode ?? _distanceFocus, _consoFocus),
            decoration: InputDecoration(
              labelText: 'Distance *',
              suffix: const Text('km'),
              errorText: distance.error,
            ),
            keyboardType: TextInputType.number,
            onChanged: distance.change,
          ),
        ),
        Selector<PleinForm, Vehicule>(
          selector: (_, form) => form.vehicule,
          builder: (context, vehicule, __) => Visibility(
            visible: vehicule.consoAffichee,
            child: Selector<PleinForm, FormElement<PleinField, String>>(
              selector: (_, form) => form.consoAffichee,
              builder: (context, consoAffichee, _) => TextField(
                focusNode: _consoFocus,
                onSubmitted: (value) {
                  _consoFocus.unfocus();
                  if (null != onSubmit) {
                    onSubmit(value);
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Consommation affichée',
                    suffix: const Text('l/100km'),
                    errorText: consoAffichee.error),
                keyboardType: TextInputType.number,
                onChanged: consoAffichee.change,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
