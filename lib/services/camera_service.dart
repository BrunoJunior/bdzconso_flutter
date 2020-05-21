import 'package:camera/camera.dart';

class CameraService {
  static CameraService _instance;
  List<CameraDescription> cameras;

  static CameraService get instance {
    assert(null != _instance, 'Please call CameraService.initialize() first !');
    return _instance;
  }

  static Future<void> initialize() async {
    if (null == _instance) {
      _instance = CameraService();
      _instance.cameras = await availableCameras();
    }
  }
}
