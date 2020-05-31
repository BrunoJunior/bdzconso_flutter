import 'package:conso/database/database.dart';
import 'package:conso/ui/composants/loader.dart';
import 'package:flutter/material.dart';

import 'vehicule_card.dart';

class VehiculesList extends StatelessWidget {
  final List<Vehicule> vehicules;

  VehiculesList(this.vehicules);

  static Widget fromStreamBuilder(
    BuildContext context,
    AsyncSnapshot<List<Vehicule>> snapshot,
  ) =>
      snapshot.hasData ? VehiculesList(snapshot.data) : const Loader();

  @override
  Widget build(BuildContext context) {
    if ((vehicules?.length ?? 0) > 0) {
      return ListView(
        children: vehicules.map(VehiculeCard.fromVehicule).toList(),
      );
    }
    return Container(
      child: const Center(
        child: const Text('Ajouter votre 1er véhicule !'),
      ),
    );
  }
}
