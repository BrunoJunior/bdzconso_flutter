import 'package:flutter/material.dart';
import 'package:fueltter/blocs/stats_bloc.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/models/stats.dart';
import 'package:fueltter/ui/composants/valeur_unite.dart';

class VehiculeStatsWidget extends StatelessWidget {
  final Vehicule vehicule;
  VehiculeStatsWidget(this.vehicule);

  @override
  Widget build(BuildContext context) {
    final StatsBloc statsBloc = StatsBloc(vehicule: vehicule);
    return StreamBuilder<Stats>(
      stream: statsBloc.outStats,
      builder: (context, snapshot) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ValeurUnite(
            unite: 'km',
            valeur: snapshot.data?.distanceCumulee ?? 0,
          ),
          ValeurUnite(
            unite: 'l/100km',
            valeur: snapshot.data?.consoMoyenne ?? 0,
          ),
        ],
      ),
    );
  }
}
