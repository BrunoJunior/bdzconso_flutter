import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final Widget icon;

  const CardTitle({
    @required this.title,
    this.icon,
    this.titleStyle = const TextStyle(fontSize: 25),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Wrap(
          children: [
            null == icon
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: icon,
                  ),
            Text(
              title,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
