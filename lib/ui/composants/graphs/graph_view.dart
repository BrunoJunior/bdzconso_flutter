import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/graph_bloc.dart';
import 'package:conso/blocs/pleins_bloc.dart';
import 'package:conso/ui/composants/graphs/graph_comparator.dart';
import 'package:conso/ui/composants/graphs/graph_selector.dart';
import 'package:conso/ui/composants/graphs/vehicule_graph.dart';
import 'package:flutter/material.dart';

class GraphView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pleinBloc = BlocProvider.of<PleinsBloc>(context);
    return BlocProvider<GraphBloc>(
      blocBuilder: () {
        final graphBloc = GraphBloc();
        pleinBloc.outListeAnnee.listen(graphBloc.inListePleins.add);
        pleinBloc.outListeAnneePrec.listen(graphBloc.inListePleinsPrec.add);
        return graphBloc;
      },
      child: Card(
        child: ListView(
          children: <Widget>[
            StreamBuilder<bool>(
                stream: pleinBloc.outListeAnneePrec.map((l) => l.isNotEmpty),
                builder: (context, snapshot) {
                  return Visibility(
                    visible: snapshot.hasData && snapshot.data,
                    child: GraphComparator(),
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: VehiculeGraph(),
            ),
            GraphSelector(),
          ],
        ),
      ),
    );
  }
}
