import 'package:flutter/material.dart';

class Height extends StatelessWidget {
  Height({super.key, required this.height});
  double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
    );
  }
}
