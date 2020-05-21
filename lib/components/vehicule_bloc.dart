import 'dart:async';
import 'dart:io';

import 'package:conso/components/valeur_unite.dart';
import 'package:conso/database/database.dart';
import 'package:conso/enums/carburants.dart';
import 'package:conso/main.dart';
import 'package:conso/screens/edit_vehicule.dart';
import 'package:conso/screens/take_picture.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' show Value;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class VehiculeBloc extends StatefulWidget {
  final Vehicule vehicule;

  VehiculeBloc(this.vehicule);

  @override
  _VehiculeBlocState createState() => _VehiculeBlocState();

  Widget getFavoris() {
    if (vehicule.carburantFavoris == null) {
      return Container();
    }
    CarburantDisplayer displayer =
        CarburantDisplayer(vehicule.carburantFavoris);
    return Chip(
      label: Text(displayer.libelle),
      padding: EdgeInsets.symmetric(),
      backgroundColor: displayer.background,
      labelStyle: TextStyle(
        color: displayer.color,
        fontSize: 12.0,
      ),
    );
  }

  Future<String> getImagePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(
        directory.path, 'vehicule_${vehicule.id}_${DateTime.now()}.png');
  }
}

class _VehiculeBlocState extends State<VehiculeBloc> {
  File photo;

  @override
  void initState() {
    photo = null != widget.vehicule.photo
        ? File(widget.vehicule.photo)
        : File('__');
    super.initState();
  }

  _onClickPicture(context) async {
    final tempPath = await Navigator.pushNamed(context, TakePictureScreen.id);
    final finalPath = await widget.getImagePath();
    if (FileUtils.rename(tempPath, finalPath)) {
      await photo.exists().then((exists) => exists ? photo.delete() : null);
      setState(() {
        photo = File(finalPath);
        database.vehiculesDao.upsert(
          widget.vehicule.toCompanion(true).copyWith(photo: Value(finalPath)),
        );
      });
    } else {
      print('Rename error');
    }
  }

  Widget _getAvatar() {
    if (null != photo && photo.existsSync()) {
      return CircleAvatar(
        radius: 35.0,
        backgroundImage: FileImage(photo),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: null == photo
          ? CircularProgressIndicator()
          : Icon(Icons.camera_enhance),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Padding(
          padding:
              EdgeInsets.only(right: 5.0, left: 50.0, top: 5.0, bottom: 5.0),
          child: RawMaterialButton(
            fillColor: Color(0xFF212121),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            onLongPress: () => Navigator.pushNamed(
              context,
              EditVehicule.id,
              arguments: widget.vehicule.toCompanion(true),
            ),
            onPressed: () {},
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.only(
                left: 50.0,
                right: 20.0,
                top: 10.0,
                bottom: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${widget.vehicule.marque} ${widget.vehicule.modele}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.vehicule.annee?.toString() ?? '',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      widget.getFavoris(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ValeurUnite(
                            unite: 'km',
                            valeur: (widget.vehicule.distance ?? 0) / 100.0,
                          ),
                          ValeurUnite(
                            unite: 'l/100km',
                            valeur: (widget.vehicule.consommation ?? 0) / 100.0,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: RawMaterialButton(
            shape: CircleBorder(),
            onPressed: () => _onClickPicture(context),
            fillColor: Color(0xFF212121),
            child: _getAvatar(),
          ),
        ),
      ],
    );
  }
}
