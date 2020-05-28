import 'package:conso/database/database.dart';
import 'package:flutter/material.dart';

import 'vehicule_widget.dart';

class VehiculesList extends StatelessWidget {
  final List<Vehicule> vehicules;

  VehiculesList(this.vehicules);

  static VehiculesList fromStreamBuilder(
    BuildContext context,
    AsyncSnapshot<List<Vehicule>> snapshot,
  ) =>
      VehiculesList(snapshot.data);

  @override
  Widget build(BuildContext context) {
    if ((vehicules?.length ?? 0) > 0) {
      return ListView(
        children: vehicules.map(VehiculeWidget.fromVehicule).toList(),
      );
    }
    return Container(
      child: Center(
        child: Text('Ajouter votre 1er véhicule !'),
      ),
    );
  }
}
