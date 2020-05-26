import 'dart:io';

import 'package:conso/database/dao/pleins_dao.dart';
import 'package:conso/database/database.dart';
import 'package:conso/enums/carburants.dart';
import 'package:conso/services/vehicule_photo_service.dart';
import 'package:conso/ui/composants/valeur_unite.dart';
import 'package:conso/ui/router.dart';
import 'package:flutter/material.dart';

class VehiculeBloc extends StatelessWidget {
  final Vehicule vehicule;
  final Stream<Stats> stats;
  VehiculeBloc(this.vehicule)
      : stats = MyDatabase.instance.pleinsDao.watchStats(vehicule.id);

  Widget get _favoris {
    if (null == vehicule.carburantFavoris) {
      return Container();
    }
    final displayer = CarburantDisplayer(vehicule.carburantFavoris);
    return Chip(
      label: Text(displayer.libelle),
      padding: EdgeInsets.symmetric(),
      backgroundColor: displayer.background,
      labelStyle: TextStyle(
        color: displayer.color,
        fontSize: 10.0,
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

  Widget get _modeleAnnee {
    return Padding(
      padding: const EdgeInsets.only(right: 43.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
        ],
      ),
    );
  }

  Widget get _stats {
    return StreamBuilder<Stats>(
      stream: stats,
      builder: (context, snapshot) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ValeurUnite(
            unite: 'km',
            valeur: (snapshot.data?.distanceCumulee ?? 0) / 100.0,
          ),
          ValeurUnite(
            unite: 'l/100km',
            valeur: snapshot.data?.consoMoyenne ?? 0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 5.0,
                left: 50.0,
                top: 5.0,
                bottom: 5.0,
              ),
              child: RawMaterialButton(
                fillColor: Color(0xFF212121),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                ),
                onLongPress: () => Navigator.pushNamed(
                  context,
                  EditVehiculeRoute,
                  arguments: vehicule,
                ),
                onPressed: () => Navigator.pushNamed(
                  context,
                  StatsVehiculeRoute,
                  arguments: vehicule,
                ),
                elevation: 5.0,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 50.0,
                    right: 10.0,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [_modeleAnnee, SizedBox(height: 10.0), _stats],
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
        ),
        Padding(
          padding: const EdgeInsets.only(right: 9.0),
          child: _favoris,
        )
      ],
    );
  }
}
