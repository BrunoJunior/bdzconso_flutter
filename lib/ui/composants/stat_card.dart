import 'dart:math';

import 'package:conso/database/converters/numeric_converter.dart';
import 'package:conso/ui/composants/card_title.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final Widget child;
  final MainAxisSize mainAxisSize;
  final GestureTapCallback onTap;

  const StatCard({
    @required this.title,
    @required this.child,
    this.icon,
    this.mainAxisSize = MainAxisSize.min,
    this.onTap,
  });

  StatCard.fromDouble({
    @required this.title,
    double value,
    int fractionDigits = 0,
    String suffix,
    this.icon,
    this.mainAxisSize = MainAxisSize.min,
    this.onTap,
  }) : child = Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              NumericConverter(fractionDigits: fractionDigits)
                  .getStringFromNumber(value),
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            null == suffix
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(suffix),
                  ),
          ],
        );

  StatCard.fromInt({
    @required this.title,
    int value,
    int fractionDigits = 0,
    bool showDigits = false,
    String suffix,
    this.icon,
    this.mainAxisSize = MainAxisSize.min,
    this.onTap,
  }) : child = Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (value / pow(10, fractionDigits))
                  .toStringAsFixed(showDigits ? fractionDigits : 0),
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            null == suffix
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(suffix),
                  ),
          ],
        );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: null == onTap ? null : Theme.of(context).buttonColor,
      elevation: null == onTap ? 0.0 : 6.0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CardTitle(
                title: title,
                icon: icon,
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
