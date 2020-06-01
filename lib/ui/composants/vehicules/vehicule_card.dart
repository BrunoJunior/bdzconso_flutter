import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fueltter/blocs/bloc_provider.dart';
import 'package:fueltter/blocs/vehicules_bloc.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/services/vehicule_photo_service.dart';
import 'package:fueltter/ui/composants/carburant_chip.dart';
import 'package:fueltter/ui/composants/vehicules/vehicule_avatar_widget.dart';
import 'package:fueltter/ui/composants/vehicules/vehicule_stats_widget.dart';
import 'package:fueltter/ui/composants/vehicules/vehicule_title_widget.dart';
import 'package:fueltter/ui/router.dart';

class VehiculeCard extends StatelessWidget {
  final Vehicule vehicule;

  VehiculeCard(this.vehicule);

  static VehiculeCard fromVehicule(Vehicule vehicule) => VehiculeCard(vehicule);

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

  @override
  Widget build(BuildContext context) {
    final VehiculesBloc vehiculesBloc = BlocProvider.of<VehiculesBloc>(context);
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
                fillColor: Theme.of(context).cardColor,
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
                onPressed: () {
                  vehiculesBloc.selectionner.add(vehicule);
                  Navigator.pushNamed(context, StatsVehiculeRoute);
                },
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
                    children: [
                      VehiculeTitleWidget(vehicule),
                      SizedBox(height: 10.0),
                      VehiculeStatsWidget(vehicule)
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
                child: VehiculeAvatarWidget(vehicule),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 9.0),
          child: CarburantChip(vehicule.carburantFavoris),
        )
      ],
    );
  }
}
