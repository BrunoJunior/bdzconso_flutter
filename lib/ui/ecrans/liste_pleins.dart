import 'package:conso/database/database.dart';
import 'package:conso/ui/router.dart';
import 'package:flutter/material.dart';

class ListePleins extends StatelessWidget {
  final Vehicule vehicule;
  final Stream<List<Plein>> pleins;

  ListePleins(this.vehicule)
      : pleins = MyDatabase.instance.pleinsDao.watchAllForVehicule(vehicule.id);

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
          .map((plein) => Text('#${plein.id} - ${plein.montant}€'))
          .toList(growable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${vehicule.marque} ${vehicule.modele} (${vehicule.annee})'),
      ),
      body: StreamBuilder<List<Plein>>(
        stream: pleins,
        builder: (context, snapshot) => (snapshot.data?.length ?? 0) > 0
            ? _getListe(snapshot.data)
            : _emptyList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          NouveauPleinRoute,
          arguments: vehicule,
        ),
        tooltip: 'Ajouter un plein',
        child: Icon(Icons.local_gas_station),
      ),
    );
  }
}
