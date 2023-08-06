import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nakama_app/Componen/ErrorDialog.dart';
import 'package:nakama_app/Componen/Height.dart';
import 'package:nakama_app/Componen/LoadingList.dart';
import 'package:nakama_app/api/getData.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  List data = [];
  bool loading = false;
  String belum_terscan = "...";
  String terscan = "...";
  void _getData() {
    if (mounted)
      setState(() {
        loading = true;
      });
    getData({"finish_tiket": "true"}).then((value) {
      if (mounted)
        setState(() {
          loading = false;
        });
      if (value == "terjadi_masalah" || value == "error") {
        ErrorDialog(context, value, _getData);
      } else {
        Map c = jsonDecode(value);
        if (mounted) {
          setState(() {
            terscan = c["terscan"];
            belum_terscan = c["belum_terscan"];
            data = jsonDecode(value)["data"];
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Dashboard",
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Text(
                "Statistik Data",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 250, 225, 255),
                        borderRadius: BorderRadius.circular(5)),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              terscan,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Height(height: 10),
                            Text(
                              "Sudah Terscan",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                        Positioned(
                            right: 0,
                            child: Icon(
                              Icons.stacked_line_chart_rounded,
                              color: const Color.fromARGB(153, 163, 163, 163),
                              size: 40,
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 250, 225, 255),
                        borderRadius: BorderRadius.circular(5)),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              belum_terscan,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Height(height: 10),
                            Text(
                              "Belum Terscan",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                        Positioned(
                            right: 0,
                            child: Icon(
                              Icons.stacked_line_chart,
                              color: const Color.fromARGB(153, 163, 163, 163),
                              size: 40,
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "Data yang telah Tersecan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: loading
                  ? LoadingList(jumlah: 4)
                  : data.length == 0
                      ? Center(
                          child: Column(
                            children: [
                              Height(height: 20),
                              Icon(
                                Icons.info_outline,
                                size: 50,
                              ),
                              Height(height: 10),
                              Text("Opss"),
                              Text(
                                "Data masih kosong",
                                style: TextStyle(
                                    color: const Color.fromARGB(174, 0, 0, 0)),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var setData = data[index];
                            return Container(
                              margin: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 15,
                              ),
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Color.fromARGB(255, 219, 239, 255)
                                    : Color.fromARGB(255, 255, 219, 223),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                trailing: Text(
                                  setData['jumlah_bayar'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 198, 33, 243),
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      setData["nama"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      setData['jenis_kelamin'],
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ))
        ],
      ),
    );
  }
}
