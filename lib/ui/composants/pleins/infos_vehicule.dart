import 'package:conso/blocs/add_plein_form_bloc.dart';
import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/database/database.dart';
import 'package:conso/ui/composants/form_card.dart';
import 'package:flutter/material.dart';

class InfosVehicule extends StatelessWidget {
  final Vehicule vehicule;
  const InfosVehicule(this.vehicule);

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<AddPleinFormBloc>(context);
    return FormCard(
      title: 'Infos véhicule',
      titleIcon: Icon(Icons.directions_car),
      children: [
        StreamBuilder<double>(
            stream: formBloc.distance,
            builder: (context, snapshot) {
              return TextField(
                decoration: InputDecoration(
                  labelText: 'Distance *',
                  suffix: Text('km'),
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
                  decoration: InputDecoration(
                      labelText: 'Consommation affichée',
                      suffix: Text('l/100km'),
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
