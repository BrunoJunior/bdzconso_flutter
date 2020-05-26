import 'package:conso/database/converters/numeric_converter.dart';
import 'package:conso/database/database.dart';
import 'package:conso/enums/carburants.dart';
import 'package:conso/services/plein_service.dart';
import 'package:conso/ui/composants/form_card.dart';
import 'package:conso/ui/composants/valeur_unite.dart';
import 'package:conso/ui/tools/form_fields_tools.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moor/moor.dart' show Value;

class FormPlein extends StatefulWidget {
  final Vehicule vehicule;
  final PleinService pleinService = PleinService();

  FormPlein({Key key, this.vehicule}) : super(key: key);

  @override
  _FormPleinState createState() => _FormPleinState();
}

class _FormPleinState extends State<FormPlein> {
  PleinsCompanion _plein;
  bool _saving = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _prixLitreController = TextEditingController();

  void _save() async {
    setState(() => _saving = true);
    try {
      if (_formKey.currentState.validate()) {
        await MyDatabase.instance.pleinsDao.addOne(_plein);
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
      initialDate: _plein.date.value,
      firstDate: DateTime(now.year - 50),
      lastDate: DateTime(now.year + 50),
    );
    _dateController.text =
        null != date ? DateFormat.yMd().format(date) : _dateController.text;
  }

  Widget getChip(Carburants carburant) {
    final CarburantDisplayer displayer = CarburantDisplayer(carburant);
    final bool selected = carburant == _plein.carburant.value;
    return ActionChip(
      label: Text(displayer.libelle),
      backgroundColor: selected ? displayer.background : Colors.black26,
      elevation: 4.0,
      labelStyle: TextStyle(
        color: selected ? displayer.color : Colors.white,
      ),
      onPressed: () =>
          setState(() => _plein = _plein.copyWith(carburant: Value(carburant))),
    );
  }

  Widget get _infosVehicule {
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
              _plein.copyWith(distance: Value(value)),
            ),
          ),
          validator: requiredValidator,
        ),
        Visibility(
          visible: widget.vehicule.consoAffichee,
          child: TextFormField(
            decoration: InputDecoration(
                labelText: 'Consommation affichée', suffix: Text('l/100km')),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(
              () => _plein = _plein.copyWith(consoAffichee: Value(value)),
            ),
            validator: requiredValidator,
          ),
        ),
      ],
    );
  }

  Widget get _infosPompe {
    return FormCard(
      title: 'Infos. pompe',
      titleIcon: Icon(Icons.local_gas_station),
      children: [
        Wrap(
          spacing: 8.0,
          alignment: WrapAlignment.center,
          children: widget.vehicule.carburantsCompatibles.map(getChip).toList(),
        ),
        SwitchListTile(
          title: Text('Additivé'),
          value: _plein.additif.value,
          onChanged: (value) =>
              setState(() => _plein = _plein.copyWith(additif: Value(value))),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Prix *', suffix: Text('€')),
          keyboardType: TextInputType.number,
          onChanged: (value) => setState(() {
            _plein = _plein.copyWith(montant: Value(value));
            _calculerPrixLitre();
          }),
          validator: requiredValidator,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Volume *', suffix: Text('L')),
          keyboardType: TextInputType.number,
          onChanged: (value) => setState(() {
            _plein = widget.pleinService.calculerConsommation(
              _plein.copyWith(volume: Value(value)),
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
        NumericConverter.cents.mapToSql(_plein.consoCalculee.value ?? '0');
    final consoAffichee =
        NumericConverter.cents.mapToSql(_plein.consoAffichee.value ?? '0');
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
    _prixLitreController.text = _plein.prixLitre.value;
  }

  @override
  void initState() {
    _plein = PleinsCompanion(
      date: Value(DateTime.now()),
      depuisPartiel: Value(false),
      partiel: Value(false),
      carburant: Value(widget.vehicule.carburantFavoris),
      additif: Value(false),
      idVehicule: Value(widget.vehicule.id),
    );
    _dateController.text = DateFormat.yMd().format(_plein.date.value);
    _dateController.addListener(() => _plein = _plein.copyWith(
        date: Value(DateFormat.yMd().parse(_dateController.text))));
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _prixLitreController.dispose();
    super.dispose();
  }

  Widget get _portraitLayout {
    return ListView(
      children: [
        _zoneDate,
        _infosVehicule,
        _consoCalculee,
        _infosPompe,
      ],
    );
  }

  Widget get _landscapeLayout {
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
                  children: [_infosVehicule, _consoCalculee]),
            ),
            SizedBox(width: 10.0),
            Expanded(child: _infosPompe),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.vehicule.marque} ${widget.vehicule.modele} (${widget.vehicule.annee})',
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
                        ? _landscapeLayout
                        : _portraitLayout),
          ),
        ),
      ),
    );
  }
}
