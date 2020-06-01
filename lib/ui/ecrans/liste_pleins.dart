import 'package:flutter/material.dart';
import 'package:fueltter/blocs/bloc_provider.dart';
import 'package:fueltter/blocs/pleins_bloc.dart';
import 'package:fueltter/ui/composants/liste_pleins.dart';
import 'package:fueltter/ui/composants/page_vehicule.dart';
import 'package:fueltter/ui/router.dart';

class EcranListePleins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageVehicule(
      title: 'Liste des pleins',
      scaffoldBuilder: (context, vehicule, scaffold) =>
          BlocProvider<PleinsBloc>(
        blocBuilder: () => PleinsBloc(vehicule: vehicule),
        child: scaffold,
      ),
      bodyBuilder: (context, vehicule) => const ListePleins(),
      fab: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NouveauPleinRoute),
        tooltip: 'Ajouter un plein',
        child: Icon(Icons.local_gas_station),
      ),
      bottomSheetBuilder: (context, vehicule) => const _BottomSheet(),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<PleinsBloc>(context).outSupprError,
      builder: (context, snapshot) => null == snapshot.data
          ? const SizedBox.shrink()
          : Container(
              child: Text(snapshot.data),
              color: Colors.redAccent,
            ),
    );
  }
}
