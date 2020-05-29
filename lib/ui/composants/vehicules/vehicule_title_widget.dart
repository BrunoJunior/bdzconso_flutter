import 'package:conso/database/database.dart';
import 'package:flutter/material.dart';

class VehiculeTitleWidget extends StatelessWidget {
  final Vehicule vehicule;
  const VehiculeTitleWidget(this.vehicule);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 43.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${vehicule.marque} ${vehicule.modele}',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            vehicule.annee?.toString() ?? '',
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
