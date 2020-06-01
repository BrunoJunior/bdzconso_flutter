import 'package:flutter/material.dart';
import 'package:fueltter/blocs/add_plein_form_bloc.dart';
import 'package:fueltter/blocs/bloc_provider.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/ui/composants/form_card.dart';
import 'package:fueltter/ui/composants/pleins/focus_changer.dart';

class InfosVehicule extends StatelessWidget with FocusChanger {
  final Vehicule vehicule;
  final FocusNode firstFocusNode;
  final ValueChanged<String> onSubmit;
  final bool autofocus;
  final FocusNode _distanceFocus = FocusNode();
  final FocusNode _consoFocus = FocusNode();

  InfosVehicule(this.vehicule,
      {this.firstFocusNode, this.onSubmit, this.autofocus = false});

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<AddPleinFormBloc>(context);
    return FormCard(
      title: 'Infos véhicule',
      titleIcon: const Icon(Icons.directions_car),
      children: [
        StreamBuilder<double>(
            stream: formBloc.distance,
            builder: (context, snapshot) {
              return TextField(
                focusNode: firstFocusNode ?? _distanceFocus,
                autofocus: autofocus,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) => fieldFocusChange(
                    context, firstFocusNode ?? _distanceFocus, _consoFocus),
                decoration: InputDecoration(
                  labelText: 'Distance *',
                  suffix: const Text('km'),
                  errorText: snapshot.error,
                ),
                keyboardType: TextInputType.number,
                onChanged: formBloc.onDistanceChanged,
              );
            }),
        Visibility(
          visible: vehicule.consoAffichee,
          child: StreamBuilder<double>(
              stream: formBloc.consoAffichee,
              builder: (context, snapshot) {
                return TextField(
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
                      errorText: snapshot.error),
                  keyboardType: TextInputType.number,
                  onChanged: formBloc.onConsoAfficheeChanged,
                );
              }),
        ),
      ],
    );
  }
}
