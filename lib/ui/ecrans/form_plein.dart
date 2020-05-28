import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/vehicules_bloc.dart';
import 'package:conso/database/converters/numeric_converter.dart';
import 'package:conso/database/database.dart';
import 'package:conso/enums/carburants.dart';
import 'package:conso/services/plein_service.dart';
import 'package:conso/ui/composants/carburant_chip.dart';
import 'package:conso/ui/composants/form_card.dart';
import 'package:conso/ui/composants/valeur_unite.dart';
import 'package:conso/ui/tools/form_fields_tools.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FormPlein extends StatefulWidget {
  final PleinService pleinService = PleinService();

  @override
  _FormPleinState createState() => _FormPleinState();
}

class _FormPleinState extends State<FormPlein> {
  Plein _plein;
  bool _saving = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _prixLitreController = TextEditingController();

  void _save() async {
    setState(() => _saving = true);
    try {
      if (_formKey.currentState.validate()) {
        await MyDatabase.instance.pleinsDao.addOne(_plein.toCompanion(true));
        Navigator.pop(context);
      }
    } catch (err) {
      print(err);
    } finally {
      setState(() => _saving = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      initialDate: _plein.date,
      firstDate: DateTime(now.year - 50),
      lastDate: DateTime(now.year + 50),
    );
    _dateController.text =
        null != date ? DateFormat.yMd().format(date) : _dateController.text;
  }

  Widget getChip(Carburants carburant) {
    // FIXME - Le state ne semble pas se mettre à jour …
    return CarburantChip(
      carburant,
      selectionne: carburant == _plein.carburant,
      onPressed: () => setState(
        () => _plein = _plein.copyWith(carburant: carburant),
      ),
    );
  }

  Widget _getInfosVehicule(Vehicule vehicule) {
    return FormCard(
      title: 'Infos. véhicule',
      titleIcon: Icon(Icons.directions_car),
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Distance *',
            suffix: Text('km'),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => setState(
            () => _plein = widget.pleinService.calculerConsommation(
              _plein.copyWith(distance: value),
            ),
          ),
          validator: requiredValidator,
        ),
        Visibility(
          visible: vehicule.consoAffichee,
          child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Consommation affichée', suffix: Text('l/100km')),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(
              () => _plein = _plein.copyWith(consoAffichee: value),
            ),
            validator: requiredValidator,
          ),
        ),
      ],
    );
  }

  Widget _getInfosPompe(Vehicule vehicule) {
    return FormCard(
      title: 'Infos. pompe',
      titleIcon: Icon(Icons.local_gas_station),
      children: [
        Wrap(
          spacing: 8.0,
          alignment: WrapAlignment.center,
          children: vehicule.carburantsCompatibles.map(getChip).toList(),
        ),
        SwitchListTile(
          title: Text('Additivé'),
          value: _plein.additif,
          onChanged: (value) =>
              setState(() => _plein = _plein.copyWith(additif: value)),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Prix *', suffix: Text('€')),
          keyboardType: TextInputType.number,
          onChanged: (value) => setState(() {
            _plein = _plein.copyWith(montant: value);
            _calculerPrixLitre();
          }),
          validator: requiredValidator,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Volume *', suffix: Text('L')),
          keyboardType: TextInputType.number,
          onChanged: (value) => setState(() {
            _plein = widget.pleinService.calculerConsommation(
              _plein.copyWith(volume: value),
            );
            _calculerPrixLitre();
          }),
          validator: requiredValidator,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Prix au litre *', suffix: Text('€/L')),
          controller: _prixLitreController,
          keyboardType: TextInputType.number,
          validator: requiredValidator,
        ),
      ],
    );
  }

  Widget get _consoCalculee {
    final consoCalculee =
        NumericConverter.cents.mapToSql(_plein.consoCalculee ?? '0');
    final consoAffichee =
        NumericConverter.cents.mapToSql(_plein.consoAffichee ?? '0');
    final diff = consoCalculee - consoAffichee;
    return FormCard(
      title: 'Consommation calculée',
      titleIcon: Icon(Icons.data_usage),
      children: [
        ValeurUnite(
          unite: 'l/100km',
          valeur: 0 != consoCalculee ? consoCalculee / 100.0 : null,
        ),
        Visibility(
          visible: 0 != diff,
          child: Text(
            '${diff > 0 ? '+' : '-'}${NumericConverter.cents.mapToDart(diff)}',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Widget get _zoneDate {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Date *',
        icon: Icon(Icons.calendar_today),
      ),
      controller: _dateController,
      focusNode: AlwaysDisabledFocusNode(),
      onTap: () => _selectDate(context),
      validator: requiredValidator,
    );
  }

  void _calculerPrixLitre() {
    _plein = widget.pleinService.calculerPrixAuLitre(_plein);
    _prixLitreController.text = _plein.prixLitre;
  }

  @override
  void initState() {
    _plein = Plein(
      id: null,
      consoAffichee: null,
      consoCalculee: null,
      distance: null,
      montant: null,
      prixLitre: null,
      volume: null,
      date: DateTime.now(),
      depuisPartiel: false,
      partiel: false,
      carburant: null,
      additif: false,
      idVehicule: null,
    );
    _dateController.text = DateFormat.yMd().format(_plein.date);
    _dateController.addListener(() => _plein =
        _plein.copyWith(date: DateFormat.yMd().parse(_dateController.text)));
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _prixLitreController.dispose();
    super.dispose();
  }

  Widget _getPortraitLayout(Vehicule vehicule) {
    return ListView(
      children: [
        _zoneDate,
        _getInfosVehicule(vehicule),
        _consoCalculee,
        _getInfosPompe(vehicule),
      ],
    );
  }

  Widget _getLandscapeLayout(Vehicule vehicule) {
    return ListView(
      children: [
        _zoneDate,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [_getInfosVehicule(vehicule), _consoCalculee]),
            ),
            SizedBox(width: 10.0),
            Expanded(child: _getInfosPompe(vehicule)),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final VehiculesBloc vehiculesBloc = BlocProvider.of<VehiculesBloc>(context);
    return StreamBuilder<Vehicule>(
        stream: vehiculesBloc.vehiculeSelectionne,
        builder: (context, snapshot) {
          final vehicule = snapshot.data;
          if (null == vehicule) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          _plein = _plein.copyWith(
              idVehicule: vehicule.id, carburant: vehicule.carburantFavoris);
          return Scaffold(
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
              actions: [IconButton(icon: Icon(Icons.save), onPressed: _save)],
            ),
            body: ModalProgressHUD(
              inAsyncCall: _saving,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Form(
                  key: _formKey,
                  child: OrientationBuilder(
                      builder: (context, orientation) =>
                          Orientation.landscape == orientation
                              ? _getLandscapeLayout(vehicule)
                              : _getPortraitLayout(vehicule)),
                ),
              ),
            ),
          );
        });
  }
}
