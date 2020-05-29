import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/graph_bloc.dart';
import 'package:flutter/material.dart';

class GraphSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GraphBloc graphBloc = BlocProvider.of<GraphBloc>(context);
    return StreamBuilder<GraphDataType>(
      stream: graphBloc.outDataType,
      builder: (context, snapshot) {
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          children: MapLabelTypes.entries.map((entry) {
            return ActionChip(
              label: Text(entry.value),
              onPressed: () => graphBloc.inDefinirTypeGraph.add(entry.key),
              backgroundColor:
                  entry.key == snapshot.data ? Colors.green : Colors.black54,
              labelStyle: TextStyle(color: Colors.white),
            );
          }).toList(),
        );
      },
    );
  }
}
