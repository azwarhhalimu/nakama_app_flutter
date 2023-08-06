import 'package:flutter/material.dart';

void LoadingDialog(BuildContext context, String label) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 4,
          ),
          width: 20,
          height: 20,
        ),
        SizedBox(
          width: 20,
        ),
        Text(label)
      ],
    ),
  );
  showDialog(
      context: context, builder: (context) => alert, barrierDismissible: false);
}
