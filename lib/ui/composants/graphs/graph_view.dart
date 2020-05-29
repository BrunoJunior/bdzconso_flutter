import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/graph_bloc.dart';
import 'package:conso/blocs/pleins_bloc.dart';
import 'package:conso/ui/composants/card_title.dart';
import 'package:conso/ui/composants/graphs/graph_comparator.dart';
import 'package:conso/ui/composants/graphs/graph_selector.dart';
import 'package:conso/ui/composants/graphs/vehicule_graph.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GraphView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GraphBloc>(
      blocBuilder: () {
        final graphBloc = GraphBloc();
        BlocProvider.of<PleinsBloc>(context)
            .outListePleinsAnnuels
            .listen(graphBloc.inListePleins.add);
        return graphBloc;
      },
      child: ListView(
        children: <Widget>[
          CardTitle(
            title: 'Suivi graphique sur 1 an',
            icon: FaIcon(FontAwesomeIcons.chartLine),
            titleStyle: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 10.0),
          GraphComparator(),
          VehiculeGraph(),
          GraphSelector(),
        ],
      ),
    );
  }
}
