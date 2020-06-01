import 'package:flutter/material.dart';
import 'package:fueltter/blocs/bloc_provider.dart';
import 'package:fueltter/blocs/pleins_bloc.dart';
import 'package:fueltter/ui/composants/graphs/graph_view.dart';
import 'package:fueltter/ui/composants/page_vehicule.dart';

class GraphsVehicule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageVehicule(
      title: 'Suivi graphique sur 1 an',
      bodyBuilder: (context, vehicule) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocProvider(
          blocBuilder: () => PleinsBloc(vehicule: vehicule),
          child: GraphView(),
        ),
      ),
    );
  }
}
