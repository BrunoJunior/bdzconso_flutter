import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  final Widget title;
  final Widget titleIcon;
  final List<Widget> children;

  const FormCard(
      {@required this.title, @required this.children, this.titleIcon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Column(
        children: [
          ListTile(
            leading: titleIcon,
            title: title,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 15.0),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
