import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GasPumpMLPage extends StatefulWidget {
  @override
  _GasPumpMLPageState createState() => _GasPumpMLPageState();
}

class _GasPumpMLPageState extends State<GasPumpMLPage> {
  Future<void> getImageFile() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.camera);
    final image = FirebaseVisionImage.fromFilePath(imageFile.path);
    final ocr = FirebaseVision.instance.textRecognizer();
    final result = await ocr.processImage(image);
    print(result.text);
    result.blocks.forEach((bloc) => print(bloc.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto-détection des infos. de pompe'),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => getImageFile(),
        tooltip: 'Prendre er photo la pompe',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
