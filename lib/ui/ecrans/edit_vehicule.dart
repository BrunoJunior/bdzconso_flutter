import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/enums/carburants.dart';
import 'package:fueltter/enums/form_statuses.dart';
import 'package:fueltter/forms/vehicule_form.dart';
import 'package:fueltter/models/vehicules_list_data.dart';
import 'package:fueltter/services/vehicule_photo_service.dart';
import 'package:fueltter/ui/composants/carburant_chip.dart';
import 'package:fueltter/validators/item_validator.dart';
import 'package:provider/provider.dart';

class EditVehicule extends StatelessWidget {
  const EditVehicule();

  @override
  Widget build(BuildContext context) {
    final vehicule = Provider.of<VehiculeListData>(context).selectedVehicule;
    return ChangeNotifierProvider(
      create: (_) => VehiculeForm(vehicule: vehicule),
      child: Scaffold(
        appBar: AppBar(
          title: Text((null == vehicule?.id)
              ? "Création véhicule"
              : "Édition véhicule"),
          actions: [const _FormAction()],
        ),
        body: Orientation.landscape == MediaQuery.of(context).orientation
            ? const _Landscape()
            : const _Portrait(),
      ),
    );
  }
}

class _FormAction extends StatelessWidget {
  const _FormAction();
  @override
  Widget build(BuildContext context) {
    return Consumer<VehiculeForm>(
      builder: (_, form, __) => IconButton(
        icon: Icon(
            FormStatus.SUBMITTING == form.status ? Icons.sync : Icons.save),
        onPressed: FormStatus.VALID == form.status
            ? () async {
                await form.onSubmit();
                Navigator.pop(context);
              }
            : null,
      ),
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(flex: 1, child: const _ZonePhoto()),
        const Expanded(flex: 2, child: const _Form()),
      ],
    );
  }
}

class _Landscape extends StatelessWidget {
  const _Landscape();
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(flex: 2, child: const _ZonePhoto()),
        const Expanded(flex: 3, child: const _Form()),
      ],
    );
  }
}

class _ZonePhoto extends StatelessWidget {
  const _ZonePhoto();
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.black12,
      child: Selector<VehiculeForm, File>(
        selector: (_, model) => model.photo,
        builder: (_, photo, __) {
          if (!photo.existsSync()) {
            return const Center(child: const Icon(Icons.camera_enhance));
          }
          return SizedBox.expand(
            child: Image(
              image: FileImage(photo),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
      onPressed: () async => Provider.of<VehiculeForm>(context, listen: false)
          .changePathPhoto(await VehiculePhotoService.instance
              .takePicture(context, autoSave: false)),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form();

  static final int anneeCourante = DateTime.now().year;

  static Iterable<DropdownMenuItem<int>> annees() sync* {
    int k = _Form.anneeCourante - 50;
    while (k <= _Form.anneeCourante)
      yield DropdownMenuItem<int>(child: Text('$k'), value: k++);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Selector<VehiculeListData, Vehicule>(
                selector: (_, data) => data.selectedVehicule,
                builder: (_, vehicule, __) {
                  final ctrl = TextEditingController(text: vehicule?.marque);
                  return Consumer<VehiculeForm>(
                    builder: (_, form, __) => TextField(
                      decoration: InputDecoration(
                        labelText: 'Marque *',
                        icon: Icon(Icons.location_city),
                        errorText: form.marque.error,
                      ),
                      controller: ctrl,
                      onChanged: form.changeMarque,
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Selector<VehiculeListData, Vehicule>(
              selector: (_, data) => data.selectedVehicule,
              builder: (_, vehicule, __) {
                final ctrl = TextEditingController(text: vehicule?.modele);
                return Consumer<VehiculeForm>(
                  builder: (_, form, __) => TextField(
                    decoration: InputDecoration(
                      labelText: 'Modèle *',
                      icon: const Icon(Icons.directions_car),
                      errorText: form.modele.error,
                    ),
                    controller: ctrl,
                    onChanged: form.changeModele,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: const EdgeInsets.only(right: 32.0),
                      child: const Icon(Icons.calendar_today),
                    ),
                    const Text(
                      'Année',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Consumer<VehiculeForm>(
                  builder: (_, form, __) => DropdownButton<int>(
                    items: _Form.annees().toList(),
                    value: form.annee.value,
                    onChanged: form.changeAnnee,
                  ),
                ),
              ],
            ),
          ),
          Consumer<VehiculeForm>(
            builder: (_, form, __) => SwitchListTile(
              title: const Text('Consommation affichée'),
              value: form.consoAffichee,
              onChanged: form.changeConsoAffichee,
              secondary: const Icon(Icons.equalizer),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 32.0),
                    child: const Icon(Icons.local_gas_station),
                  ),
                  const Text(
                    "Carburants compatibles",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Wrap(
                spacing: 8.0,
                alignment: WrapAlignment.center,
                children: Carburant.values
                    .map((carburant) => _CarburantsChip(carburant))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarburantsChip extends StatelessWidget {
  final Carburant carburant;
  _CarburantsChip(this.carburant);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Selector<VehiculeForm, ValidatedItem<UnmodifiableListView<Carburant>>>(
            selector: (_, form) => form.carburantsCompatibles,
            builder: (_, validated, __) {
              final selectionne =
                  validated.hasValue() && validated.value.contains(carburant);
              return CarburantChip(
                carburant,
                selectionne: selectionne,
                onPressed: () =>
                    Provider.of<VehiculeForm>(context, listen: false)
                        .toggleCarburantCompatible(carburant),
              );
            }),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Consumer<VehiculeForm>(builder: (context, form, _) {
            return Visibility(
              visible: form.carburantsCompatibles.hasValue() &&
                  form.carburantsCompatibles.value.contains(carburant),
              child: InkWell(
                onTap: () => form.changeCarburantFavoris(carburant),
                child: Icon(
                  carburant == form.carburantFavoris.value
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.yellow,
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
