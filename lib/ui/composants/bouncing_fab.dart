import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class BouncingFAB extends StatelessWidget {
  final FloatingActionButton child;
  final bool deactivate;
  BouncingFAB({this.child, this.deactivate = false});

  @override
  Widget build(BuildContext context) {
    if (deactivate) {
      return child;
    }
    return MirrorAnimation<double>(
      tween: (1.0).tweenTo(1.5),
      duration: 1.seconds,
      curve: Curves.elasticIn,
      builder: (context, child, value) => Transform.scale(
        scale: value,
        child: child,
      ),
      child: FittedBox(
        child: child,
      ),
    );
  }
}
