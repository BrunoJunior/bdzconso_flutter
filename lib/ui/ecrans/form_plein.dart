import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fueltter/blocs/add_plein_form_bloc.dart';
import 'package:fueltter/blocs/bloc_provider.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/models/vehicules_list_data.dart';
import 'package:fueltter/ui/composants/pleins/focus_changer.dart';
import 'package:fueltter/ui/composants/pleins/infos_pompes.dart';
import 'package:fueltter/ui/composants/pleins/infos_vehicule.dart';
import 'package:fueltter/ui/composants/pleins/save_form.dart';
import 'package:fueltter/ui/composants/pleins/valeurs_calculee.dart';
import 'package:fueltter/ui/composants/pleins/zone_date.dart';
import 'package:provider/provider.dart';

/// Écran
class FormPlein extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<VehiculeListData, Vehicule>(
      selector: (_, data) => data.selectedVehicule,
      builder: (_, vehicule, __) => BlocProvider<AddPleinFormBloc>(
        blocBuilder: () => AddPleinFormBloc(vehicule),
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicule.marque} ${vehicule.modele} (${vehicule.annee})',
                  style: const TextStyle(fontSize: 10.0),
                ),
                const Text('Nouveau plein'),
              ],
            ),
            actions: [const SaveForm()],
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 80.0),
            child: _Form(vehicule),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: const ValeursCalculees(),
          ),
        ),
      ),
    );
  }
}

/// Formulaire
class _Form extends StatefulWidget {
  final Vehicule vehicule;
  final FocusNode vehiculeFocus = FocusNode();
  final FocusNode pompeFocus = FocusNode();
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
          ? _LandscapeLayout(widget)
          : _PortraitLayout(widget),
    );
  }

  @override
  void dispose() {
    submitSub?.cancel();
    super.dispose();
  }
}

/// Portrait
class _PortraitLayout extends StatelessWidget with FocusChanger {
  final _Form form;
  _PortraitLayout(this.form);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ZoneDate(),
        InfosVehicule(
          form.vehicule,
          firstFocusNode: form.vehiculeFocus,
          autofocus: true,
          onSubmit: (v) =>
              fieldFocusChange(context, form.vehiculeFocus, form.pompeFocus),
        ),
        InfosPompe(
          form.vehicule,
          firstFocusNode: form.pompeFocus,
          onSubmit: (v) => form.pompeFocus.unfocus(),
        ),
      ],
    );
  }
}

/// Paysage
class _LandscapeLayout extends StatelessWidget with FocusChanger {
  final _Form form;
  _LandscapeLayout(this.form);
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
                  const ZoneDate(),
                  InfosVehicule(
                    form.vehicule,
                    autofocus: true,
                    firstFocusNode: form.vehiculeFocus,
                    onSubmit: (v) => fieldFocusChange(
                      context,
                      form.vehiculeFocus,
                      form.pompeFocus,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
                child: InfosPompe(
              form.vehicule,
              firstFocusNode: form.pompeFocus,
              onSubmit: (v) => form.pompeFocus.unfocus(),
            )),
          ],
        )
      ],
    );
  }
}
