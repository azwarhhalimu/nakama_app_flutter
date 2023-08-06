import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nakama_app/Componen/Alert.dart';
import 'package:nakama_app/MainPage/Beranda.dart';
import 'package:nakama_app/MainPage/Data_peserta.dart';
import 'package:nakama_app/MainPage/Scan.dart';

class MainPage extends StatefulWidget {
  static String routeName = "beranda";
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int aktifPage = 0;
  List page = [
    Beranda(),
    Scan(),
    Data_peserta(),
  ];
  @override
  Widget build(BuildContext context) {
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    return WillPopScope(
      onWillPop: () async {
        if (aktifPage != 0) {
          if (mounted) {
            setState(() {
              aktifPage = 0;
            });
          }
        } else {
          alert(
            context,
            "Perhatian",
            "Apakah anda ingin keluar dari aplikasi",
            [
              TextButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: Text("Ya")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Tidak")),
            ],
          );
        }
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: page[aktifPage],
                ),
                Visibility(
                  visible: keyboard > 0 ? false : true,
                  child: BottomNavigationBar(
                      selectedFontSize: 13,
                      unselectedFontSize: 13,
                      currentIndex: aktifPage,
                      onTap: (value) {
                        if (mounted) {
                          setState(() {
                            aktifPage = value;
                          });
                        }
                      },
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined),
                          label: "Beranda",
                        ),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.abc), label: ""),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.groups_2_outlined),
                          label: "Data Nakama",
                        ),
                      ]),
                ),
              ],
            ),
            Positioned(
                left: (MediaQuery.of(context).size.width * .5) - 27.5,
                bottom: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        aktifPage = 1;
                      });
                    }
                  },
                  child: Icon(
                    Icons.qr_code_scanner_outlined,
                    size: 30,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
