import 'dart:io';

import 'package:conso/database/database.dart';
import 'package:conso/enums/carburants.dart';
import 'package:conso/services/vehicule_photo_service.dart';
import 'package:conso/ui/tools/form_fields_tools.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' show Value;

class EditVehicule extends StatefulWidget {
  static final int anneeCourante = DateTime.now().year;
  final Vehicule vehicule;

  EditVehicule({Key key, this.vehicule}) : super(key: key);

  Iterable<int> annees() sync* {
    int k = anneeCourante - 50;
    while (k <= anneeCourante) yield k++;
  }

  @override
  _EditVehiculeState createState() => _EditVehiculeState();
}

class _EditVehiculeState extends State<EditVehicule> {
  final _formKey = GlobalKey<FormState>();
  VehiculesCompanion vehicule;

  void initState() {
    vehicule = widget.vehicule?.toCompanion(true) ??
        VehiculesCompanion(
          consoAffichee: Value(true),
          annee: Value(EditVehicule.anneeCourante),
          carburantsCompatibles: Value([]),
        );
    super.initState();
  }

  _save() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    try {
      final bool hadPhoto = widget.vehicule?.photo?.isNotEmpty ?? false;
      if (hadPhoto && widget.vehicule?.photo != vehicule.photo.value) {
        await VehiculePhotoService.instance.getPhoto(widget.vehicule).delete();
      }
      await MyDatabase.instance.vehiculesDao.upsert(vehicule);
      Navigator.pop(context);
    } catch (err) {
      print(err);
    }
  }

  Widget get _image {
    File photo = VehiculePhotoService.instance.getCompanionPhoto(vehicule);
    if (!photo.existsSync()) {
      return Center(
        child: Icon(Icons.camera_enhance),
      );
    }
    return SizedBox.expand(
      child: Image(
        image: FileImage(photo),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget getChip(Carburants carburant) {
    final CarburantDisplayer displayer = CarburantDisplayer(carburant);
    List<Carburants> compatibles = vehicule.carburantsCompatibles.value;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ActionChip(
          label: Text(displayer.libelle),
          backgroundColor: compatibles.contains(carburant)
              ? displayer.background
              : Colors.black26,
          elevation: 4.0,
          labelStyle: TextStyle(
              color: compatibles.contains(carburant)
                  ? displayer.color
                  : Colors.white),
          onPressed: () => setState(() {
            if (!compatibles.remove(carburant)) {
              vehicule = vehicule.copyWith(
                  carburantsCompatibles: Value(
                      [...vehicule.carburantsCompatibles.value, carburant]),
                  carburantFavoris:
                      Value(vehicule.carburantFavoris.value ?? carburant));
            } else if (carburant == vehicule.carburantFavoris.value) {
              vehicule = vehicule.copyWith(
                  carburantFavoris: 0 == compatibles.length
                      ? Value.absent()
                      : Value(compatibles.first));
            }
          }),
        ),
        Visibility(
          visible: vehicule.carburantsCompatibles.value?.contains(carburant) ??
              false,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: () => setState(() => vehicule =
                  vehicule.copyWith(carburantFavoris: Value(carburant))),
              child: Icon(
                carburant == vehicule.carburantFavoris.value
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.yellow,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget get _zonePhoto {
    return RawMaterialButton(
      fillColor: Colors.black12,
      child: _image,
      onPressed: () async {
        final vehiculeWithPhoto =
            await VehiculePhotoService.instance.takePicture(context, vehicule);
        setState(() => vehicule = vehiculeWithPhoto);
      },
    );
  }

  Widget get _zoneForm {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Marque *',
              icon: Icon(Icons.location_city),
            ),
            initialValue: vehicule.marque.value ?? '',
            onChanged: (String value) =>
                vehicule = vehicule.copyWith(marque: Value(value)),
            validator: requiredValidator,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Modèle *',
              icon: Icon(Icons.directions_car),
            ),
            initialValue: vehicule.modele.value ?? '',
            onChanged: (String value) =>
                vehicule = vehicule.copyWith(modele: Value(value)),
            validator: requiredValidator,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 32.0),
                    child: Icon(Icons.calendar_today),
                  ),
                  Text(
                    'Année',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              DropdownButton<int>(
                items: widget
                    .annees()
                    .map(
                      (value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                        ),
                      ),
                    )
                    .toList(),
                value: vehicule.annee.value,
                onChanged: (value) => setState(
                  () => vehicule = vehicule.copyWith(annee: Value(value)),
                ),
              )
            ],
          ),
        ),
        SwitchListTile(
          title: Text('Consommation affichée'),
          value: vehicule.consoAffichee.value,
          onChanged: (bool value) => setState(
              () => vehicule = vehicule.copyWith(consoAffichee: Value(value))),
          secondary: const Icon(Icons.equalizer),
        ),
        Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 32.0),
                  child: Icon(Icons.local_gas_station),
                ),
                Text(
                  "Carburants compatibles",
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Wrap(
              spacing: 8.0,
              alignment: WrapAlignment.center,
              children: Carburants.values.map(getChip).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _portraitLayout {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 1, child: _zonePhoto),
        Expanded(flex: 3, child: _zoneForm),
      ],
    );
  }

  Widget get _landscapeLayout {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 1, child: _zonePhoto),
        Expanded(flex: 2, child: _zoneForm),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(null == vehicule.id.value
            ? "Création véhicule"
            : "Édition véhicule"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _save,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: OrientationBuilder(
          builder: (context, orientation) =>
              Orientation.landscape == orientation
                  ? _landscapeLayout
                  : _portraitLayout,
        ),
      ),
    );
  }
}
