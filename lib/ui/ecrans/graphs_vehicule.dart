import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/pleins_bloc.dart';
import 'package:conso/ui/composants/graphs/graph_view.dart';
import 'package:conso/ui/composants/page_vehicule.dart';
import 'package:flutter/material.dart';

class GraphsVehicule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageVehicule(
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
