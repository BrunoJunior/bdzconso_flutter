import 'package:flutter/material.dart';
import 'package:fueltter/models/vehicules_list_data.dart';
import 'package:provider/provider.dart';

import 'vehicule_card.dart';

class VehiculesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VehiculeListData>(builder: (_, modele, __) {
      if (modele.vehicules.length > 0) {
        return ListView.builder(
          itemCount: modele.vehicules.length,
          itemBuilder: (_, index) => VehiculeCard(modele.vehicules[index]),
        );
      }
      return Container(
        child: const Center(
          child: const Text('Ajouter votre 1er véhicule !'),
        ),
      );
    });
  }
}
