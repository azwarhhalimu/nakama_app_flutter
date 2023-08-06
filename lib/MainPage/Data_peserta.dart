import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nakama_app/Componen/Alert.dart';
import 'package:nakama_app/Componen/ErrorDialog.dart';
import 'package:nakama_app/Componen/Height.dart';
import 'package:nakama_app/Componen/LoadingDialog.dart';
import 'package:nakama_app/Componen/LoadingList.dart';
import 'package:nakama_app/MainPage/Tambah_data.dart';
import 'package:nakama_app/api/deleteData.dart';
import 'package:nakama_app/api/getData.dart';
import 'package:url_launcher/url_launcher.dart';

class Data_peserta extends StatefulWidget {
  const Data_peserta({super.key});

  @override
  State<Data_peserta> createState() => _Data_pesertaState();
}

class _Data_pesertaState extends State<Data_peserta> {
  bool loading = true;
  List data = [];
  String cari = "";
  void _deleteData(String id_data) {
    alert(context, "Perhatian", "Apakah anda ingin menghapus data ini?", [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
            LoadingDialog(context, "Menghapus ...");
            deleteData({"id_data": id_data}).then((value) {
              Navigator.pop(context);
              if (value == "terjadi_masalah" || value == "error") {
                ErrorDialog(context, value, () {
                  Navigator.pop(context);
                });
              } else {
                String status = jsonDecode(value)["status"];
                if (status == "data_berhasil_di_hapus") {
                  alert(context, "Sukses", "Data berhasil di hapus", [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Ok"))
                  ]);

                  _getData();
                }
              }
            });
          },
          child: Text("Ya")),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Tidak")),
    ]);
  }

  void _getData() {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    getData({}).then((value) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      if (value == "terjadi_masalah" || value == "error") {
        ErrorDialog(context, value, _getData);
      } else {
        if (mounted) {
          setState(() {
            data = jsonDecode(value)["data"];
          });
        }
      }
    });
  }

  @override
  void initState() {
    _getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Tambah_data(
                  data_edit: {"nama": ""},
                );
              })).then((value) {
                if (value == "refresh") {
                  _getData();
                }
              });
            },
            label: Text(
              "Tambah",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
        title: Text(
          "Data Nakama",
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: Column(children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            width: 2,
            color: Colors.black12,
          ))),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      cari = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Masukkan pencarian",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Column(
                children: [
                  Text("Total Data"),
                  Text(data.length.toString() + " Data")
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: loading
              ? LoadingList(jumlah: 6)
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var setData = data[index];
                    List pesanan = jsonDecode(setData["pesanan"]);
                    return setData["nama"]
                            .toString()
                            .toLowerCase()
                            .contains(cari.toString().toLowerCase())
                        ? Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.black12))),
                            child: ExpansionTile(
                              leading: Text((index + 1).toString()),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    setData["nama"],
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(setData["jumlah_bayar"]),
                                  Text(
                                    setData["jenis_kelamin"],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        String link =
                                            "https://nakama-baubau.vercel.app?code=";
                                        final Uri _url = Uri.parse(
                                            'https://api.whatsapp.com/send?text=${link}${setData["id_data"]}');
                                        if (!await launchUrl(_url,
                                            mode: LaunchMode
                                                .externalNonBrowserApplication)) {
                                          throw Exception(
                                              'Could not launch $_url');
                                        }
                                      },
                                      child: Text("Shere Tiket"))
                                ],
                              ),
                              children: [
                                Height(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          _deleteData(setData["id_data"]);
                                        },
                                        label: Text("Hapus"),
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return Tambah_data(
                                              data_edit: setData,
                                            );
                                          })).then((value) {
                                            if (value == "refresh") {
                                              _getData();
                                            }
                                          });
                                        },
                                        label: Text("Edit"),
                                        icon: Icon(Icons.edit),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(),
                                Text(
                                  "Data Pesanan Pre Order",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Height(height: 10),
                                for (int i = 0; i < pesanan.length; i++)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 60, bottom: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child:
                                              Text(pesanan[i]["nama_pesanan"]),
                                        ),
                                        Expanded(
                                          child: Text(
                                              pesanan[i]["jumlah"] + " Item"),
                                        )
                                      ],
                                    ),
                                  ),
                                Height(height: 20),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, bottom: 10),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Keterangan",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(setData["keterangan"]),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container();
                  },
                ),
        ),
      ]),
    );
  }
}
