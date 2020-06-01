import 'package:flutter/material.dart';
import 'package:fueltter/ui/composants/card_title.dart';

class FormCard extends StatelessWidget {
  final String title;
  final Widget titleIcon;
  final List<Widget> children;

  const FormCard(
      {@required this.title, @required this.children, this.titleIcon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CardTitle(
              title: title,
              icon: titleIcon,
              titleStyle: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 8.0),
            Center(child: Column(children: children)),
          ],
        ),
      ),
    );
  }
}
