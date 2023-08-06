import 'package:flutter/material.dart';
import 'package:nakama_app/MainPage.dart';
import 'package:nakama_app/MainPage/Login.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nakama Aplikasi',
      initialRoute: Login.routeName,
      routes: {
        MainPage.routeName: (context) => MainPage(),
        Login.routeName: (context) => Login(),
      },
    );
  }
}
