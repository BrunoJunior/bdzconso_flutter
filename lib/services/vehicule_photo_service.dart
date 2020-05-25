import 'dart:io';

import 'package:conso/database/database.dart';
import 'package:conso/ui/router.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:moor/moor.dart' show Value;
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

  Future<VehiculesCompanion> takePicture(
      BuildContext context, VehiculesCompanion vehicule) async {
    final tempPath = await Navigator.pushNamed(context, TakePictureRoute);
    final String finalPath = await getImagePath();
    if (null != tempPath && FileUtils.rename(tempPath, finalPath)) {
      return vehicule.copyWith(photo: Value(finalPath));
    } else if (null == tempPath) {
      return vehicule;
    } else {
      throw new Exception('Erreur lors de la sauvegarde de la photo');
    }
  }
}
