import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/services/vehicule_photo_service.dart';

class VehiculeAvatarWidget extends StatelessWidget {
  final File photo;

  VehiculeAvatarWidget(Vehicule vehicule)
      : photo = VehiculePhotoService.instance.getPhoto(vehicule);

  @override
  Widget build(BuildContext context) {
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
}
