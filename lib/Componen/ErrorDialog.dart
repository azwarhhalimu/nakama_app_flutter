import 'package:flutter/material.dart';
import 'package:nakama_app/Componen/Alert.dart';

void ErrorDialog(BuildContext context, String value, Function target) {
  if (value == "terjadi_masalah") {
    alert(context, "Opsss", "Internal server bermasalah", [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Oke"))
    ]);
  } else if (value == "error") {
    alert(context, "Internet bermasalah", "Koneksi internet bermasalah", [
      TextButton(
          onPressed: () {
            target();
            Navigator.pop(context);
          },
          child: Text("Coba Lagi"))
    ]);
  }
}
