import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/pleins_bloc.dart';
import 'package:conso/database/database.dart';
import 'package:flutter/material.dart';

class ListePleins extends StatelessWidget {
  Widget get _emptyList {
    return Center(
      child: Text(
        'Aucun pleins pour le moment',
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _getListe(List<Plein> pleins) {
    return ListView(
      children: pleins
          .map(
            (plein) => RaisedButton(
              child: Text(
                  '#${plein.id} - ${plein.date.toIso8601String()} - ${plein.montant}€'),
              onPressed: () => MyDatabase.instance.pleinsDao.deleteOne(plein),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    PleinsBloc pleinsBloc = BlocProvider.of<PleinsBloc>(context);
    return StreamBuilder<List<Plein>>(
      stream: pleinsBloc.outListe,
      builder: (context, snapshot) => (snapshot.data?.length ?? 0) > 0
          ? _getListe(snapshot.data)
          : _emptyList,
    );
  }
}
