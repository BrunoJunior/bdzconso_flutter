import 'dart:async';

import 'package:conso/blocs/add_plein_form_bloc.dart';
import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/vehicules_bloc.dart';
import 'package:conso/database/database.dart';
import 'package:conso/ui/composants/loader.dart';
import 'package:conso/ui/composants/pleins/infos_pompes.dart';
import 'package:conso/ui/composants/pleins/infos_vehicule.dart';
import 'package:conso/ui/composants/pleins/save_form.dart';
import 'package:conso/ui/composants/pleins/valeurs_calculee.dart';
import 'package:conso/ui/composants/pleins/zone_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Écran
class FormPlein extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VehiculesBloc vehiculesBloc = BlocProvider.of<VehiculesBloc>(context);
    return StreamBuilder<Vehicule>(
      stream: vehiculesBloc.vehiculeSelectionne,
      builder: (context, snapshot) {
        final vehicule = snapshot.data;
        if (null == vehicule) {
          return Loader();
        }
        return BlocProvider<AddPleinFormBloc>(
          blocBuilder: () => AddPleinFormBloc(vehicule),
          child: Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicule.marque} ${vehicule.modele} (${vehicule.annee})',
                    style: TextStyle(fontSize: 10.0),
                  ),
                  Text('Nouveau plein'),
                ],
              ),
              actions: [SaveForm()],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 80.0),
              child: _Form(vehicule),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ValeursCalculees(),
            ),
          ),
        );
      },
    );
  }
}

/// Formulaire
class _Form extends StatefulWidget {
  final Vehicule vehicule;
  _Form(this.vehicule);
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  StreamSubscription submitSub;

  @override
  Widget build(BuildContext context) {
    AddPleinFormBloc formBloc = BlocProvider.of<AddPleinFormBloc>(context);
    // La sauvegarde a été effectuée, on ferme l'écran
    submitSub = formBloc.isSaved
        .where((saved) => saved ?? false)
        .listen((val) => Navigator.pop(context));
    return Form(
      child: Orientation.landscape == MediaQuery.of(context).orientation
          ? _LandscapeLayout(widget.vehicule)
          : _PortraitLayout(widget.vehicule),
    );
  }

  @override
  void dispose() {
    submitSub?.cancel();
    super.dispose();
  }
}

/// Portrait
class _PortraitLayout extends StatelessWidget {
  final Vehicule vehicule;
  _PortraitLayout(this.vehicule);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ZoneDate(),
        InfosVehicule(vehicule),
        InfosPompe(vehicule),
      ],
    );
  }
}

/// Paysage
class _LandscapeLayout extends StatelessWidget {
  final Vehicule vehicule;
  _LandscapeLayout(this.vehicule);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ZoneDate(),
                  InfosVehicule(vehicule),
                ],
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(child: InfosPompe(vehicule)),
          ],
        )
      ],
    );
  }
}
