import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x80333333),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
