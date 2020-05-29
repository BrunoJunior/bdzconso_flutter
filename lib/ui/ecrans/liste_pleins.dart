import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/pleins_bloc.dart';
import 'package:conso/ui/composants/liste_pleins.dart';
import 'package:conso/ui/composants/page_vehicule.dart';
import 'package:conso/ui/router.dart';
import 'package:flutter/material.dart';

class EcranListePleins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageVehicule(
      bodyBuilder: (context, vehicule) => BlocProvider<PleinsBloc>(
        blocBuilder: () => PleinsBloc(vehicule: vehicule),
        child: ListePleins(),
      ),
      fab: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NouveauPleinRoute),
        tooltip: 'Ajouter un plein',
        child: Icon(Icons.local_gas_station),
      ),
    );
  }
}
