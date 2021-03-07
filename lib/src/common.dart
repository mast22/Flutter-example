import 'package:flutter/material.dart';

class CommonWidgets {
  static ListTile buildTile(BuildContext context, String title, Widget route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
    );
  }
}
