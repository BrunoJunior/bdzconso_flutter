import 'dart:async';
import 'dart:io';

import 'package:file_utils/file_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/ui/router.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class VehiculePhotoService {
  static VehiculePhotoService _instance;

  static VehiculePhotoService get instance {
    if (null == _instance) {
      _instance = VehiculePhotoService();
    }
    return _instance;
  }

  Future<String> getImagePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final moment = DateTime.now();
    final incPart =
        '${moment.year}${moment.month}${moment.day}_${moment.hour}${moment.minute}${moment.second}';
    return join(directory.path, 'vehicule_$incPart.png');
  }

  File getPhoto(Vehicule vehicule) {
    return File(vehicule.photo ?? '__');
  }

  File getCompanionPhoto(VehiculesCompanion vehicule) {
    return File(vehicule.photo.value ?? '__');
  }

  Future<String> takePicture(BuildContext context,
      {bool autoSave = true}) async {
    final tempPath = await Navigator.pushNamed(context, TakePictureRoute);
    return autoSave ? await movePhotoInFinalPath(tempPath) : tempPath;
  }

  Future<String> movePhotoInFinalPath(String tempPath) async {
    final String finalPath = await getImagePath();
    if (null != tempPath && FileUtils.rename(tempPath, finalPath)) {
      return finalPath;
    } else if (null == tempPath) {
      return null;
    } else {
      throw new Exception('Erreur lors de la sauvegarde de la photo');
    }
  }
}
