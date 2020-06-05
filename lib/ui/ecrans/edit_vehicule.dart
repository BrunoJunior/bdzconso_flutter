import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/forms/form.dart';
import 'package:fueltter/forms/form_element.dart';
import 'package:fueltter/forms/vehicule_form.dart';
import 'package:fueltter/models/carburant.dart';
import 'package:fueltter/models/vehicules_list_data.dart';
import 'package:fueltter/services/vehicule_photo_service.dart';
import 'package:fueltter/ui/composants/carburant_chip.dart';
import 'package:provider/provider.dart';

class EditVehicule extends StatelessWidget {
  const EditVehicule();

  @override
  Widget build(BuildContext context) => Selector<VehiculeListData, Vehicule>(
        selector: (_, data) => data.selectedVehicule,
        builder: (context, vehicule, _) => ChangeNotifierProvider(
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
        ),
      );
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
                Provider.of<VehiculeListData>(context, listen: false)
                    .selectedVehicule = null;
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
        selector: (_, form) => form.photo,
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
          .photoPath
          .change(await VehiculePhotoService.instance
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
                  return Selector<VehiculeForm,
                      FormElement<VehiculeField, String>>(
                    selector: (_, form) => form.marque,
                    builder: (_, marque, __) => TextField(
                      decoration: InputDecoration(
                        labelText: 'Marque *',
                        icon: Icon(Icons.location_city),
                        errorText: marque.error,
                      ),
                      controller: ctrl,
                      onChanged: marque.change,
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
                return Selector<VehiculeForm,
                    FormElement<VehiculeField, String>>(
                  selector: (_, form) => form.modele,
                  builder: (_, modele, __) => TextField(
                    decoration: InputDecoration(
                      labelText: 'Modèle *',
                      icon: const Icon(Icons.directions_car),
                      errorText: modele.error,
                    ),
                    controller: ctrl,
                    onChanged: modele.change,
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
                Selector<VehiculeForm, FormElement<VehiculeField, int>>(
                  selector: (_, form) => form.annee,
                  builder: (_, annee, __) => DropdownButton<int>(
                    items: _Form.annees().toList(),
                    value: annee.value,
                    onChanged: annee.change,
                  ),
                ),
              ],
            ),
          ),
          Selector<VehiculeForm, FormElement<VehiculeField, bool>>(
            selector: (_, form) => form.consoAffichee,
            builder: (_, consoAffichee, __) => SwitchListTile(
              title: const Text('Consommation affichée'),
              value: consoAffichee.value,
              onChanged: consoAffichee.change,
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
        Selector<VehiculeForm, UnmodifiableListView<Carburant>>(
            selector: (_, form) => form.carburantsCompatibles,
            builder: (_, carburants, __) {
              final selectionne = carburants.contains(carburant);
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
          child: Selector<VehiculeForm, bool>(
            selector: (_, form) =>
                form.carburantsCompatibles.contains(carburant),
            builder: (context, visible, _) {
              return Visibility(
                visible: visible,
                child: Selector<VehiculeForm,
                    FormElement<VehiculeField, Carburant>>(
                  selector: (_, form) => form.carburantFavoris,
                  builder: (_, favoris, __) => InkWell(
                    onTap: () => favoris.change(carburant),
                    child: Icon(
                      carburant == favoris.value
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.yellow,
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
