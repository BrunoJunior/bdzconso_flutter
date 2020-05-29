import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/graph_bloc.dart';
import 'package:flutter/material.dart';

class GraphComparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GraphBloc graphBloc = BlocProvider.of<GraphBloc>(context);
    return StreamBuilder<bool>(
      stream: graphBloc.outComparaison,
      builder: (context, snapshot) => SwitchListTile(
        title: Text('Comparaison année n-1'),
        value: snapshot.data ?? false,
        onChanged: graphBloc.inComparer.add,
      ),
    );
  }
}
