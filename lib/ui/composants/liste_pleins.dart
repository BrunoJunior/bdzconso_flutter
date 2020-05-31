import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/pleins_bloc.dart';
import 'package:conso/database/database.dart';
import 'package:conso/ui/composants/pleins/plein_list_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListePleins extends StatelessWidget {
  const ListePleins();

  @override
  Widget build(BuildContext context) {
    PleinsBloc pleinsBloc = BlocProvider.of<PleinsBloc>(context);
    return StreamBuilder<List<Plein>>(
      stream: pleinsBloc.outListe,
      builder: (context, snapshot) {
        final listSize = snapshot.data?.length ?? 0;
        if (0 == listSize) {
          return const _EmptyList();
        }
        return ListView.builder(
          itemCount: listSize,
          itemBuilder: (context, index) {
            final plein = snapshot.data[index];
            return PleinListElement(
              plein,
              onDismissed: (direction) => pleinsBloc.inSupprimer.add(plein),
            );
          },
        );
      },
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Aucun pleins pour le moment',
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }
}
