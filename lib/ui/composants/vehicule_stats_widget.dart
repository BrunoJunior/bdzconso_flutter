import 'package:conso/blocs/stats_bloc.dart';
import 'package:conso/database/dao/pleins_dao.dart';
import 'package:conso/database/database.dart';
import 'package:conso/ui/composants/valeur_unite.dart';
import 'package:flutter/material.dart';

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
            valeur: (snapshot.data?.distanceCumulee ?? 0) / 100.0,
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
