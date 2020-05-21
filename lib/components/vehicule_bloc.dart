import 'dart:io';

import 'package:conso/components/valeur_unite.dart';
import 'package:conso/database/database.dart';
import 'package:conso/enums/carburants.dart';
import 'package:conso/screens/edit_vehicule.dart';
import 'package:conso/services/vehicule_photo_service.dart';
import 'package:flutter/material.dart';

class VehiculeBloc extends StatelessWidget {
  final Vehicule vehicule;
  VehiculeBloc(this.vehicule);

  Widget get _favoris {
    final displayer =
        CarburantDisplayer(vehicule.carburantFavoris ?? Carburants.DIESEL);
    return Visibility(
      visible: vehicule.carburantFavoris != null,
      child: Chip(
        label: Text(displayer.libelle),
        padding: EdgeInsets.symmetric(),
        backgroundColor: displayer.background,
        labelStyle: TextStyle(
          color: displayer.color,
          fontSize: 12.0,
        ),
      ),
    );
  }

  _onClickPicture(context) async {
    try {
      final VehiculesCompanion updatedVehicule = await VehiculePhotoService
          .instance
          .takePicture(context, vehicule.toCompanion(true));
      if (vehicule.photo != updatedVehicule.photo.value) {
        File photo = VehiculePhotoService.instance.getPhoto(vehicule);
        await photo.exists().then((exists) => exists ? photo.delete() : null);
        MyDatabase.instance.vehiculesDao.upsert(updatedVehicule);
      }
    } catch (err) {
      print(err);
    }
  }

  Widget get _avatar {
    File photo = VehiculePhotoService.instance.getPhoto(vehicule);
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
              arguments: vehicule.toCompanion(true),
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
                    '${vehicule.marque} ${vehicule.modele}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    vehicule.annee?.toString() ?? '',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _favoris,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ValeurUnite(
                            unite: 'km',
                            valeur: (vehicule.distance ?? 0) / 100.0,
                          ),
                          ValeurUnite(
                            unite: 'l/100km',
                            valeur: (vehicule.consommation ?? 0) / 100.0,
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
            child: _avatar,
          ),
        ),
      ],
    );
  }
}
