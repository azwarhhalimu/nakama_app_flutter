import 'package:flutter/material.dart';

alert(
    BuildContext context, String title, String subTitle, List<Widget> action) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(subTitle),
    actions: action,
  );
  showDialog(
    context: context,
    builder: (context) {
      return alertDialog;
    },
  );
}
