import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nakama_app/Componen/Alert.dart';
import 'package:nakama_app/Componen/ErrorDialog.dart';
import 'package:nakama_app/Componen/Height.dart';
import 'package:nakama_app/Componen/LoadingDialog.dart';
import 'package:nakama_app/MainPage/Pesanan_list.dart';
import 'package:nakama_app/api/saveData.dart';

class Tambah_data extends StatefulWidget {
  Tambah_data({
    super.key,
    required this.data_edit,
  });

  Map<dynamic, dynamic> data_edit;

  @override
  State<Tambah_data> createState() => _Tambah_dataState();
}

class _Tambah_dataState extends State<Tambah_data> {
  String pesanan = "";
  String jenis_kelamin = "Laki-laki";
  var nama = TextEditingController();
  var keterangan = TextEditingController();
  var jumlah_bayar = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  void simpan() {
    if (_formKey.currentState!.validate()) {
      Map formData = {
        "nama": nama.text,
        "jenis_kelamin": jenis_kelamin,
        "jumlah_bayar": jumlah_bayar.text,
        "pesanan": jsonEncode(data_pesanan),
        'keterangan': keterangan.text,
      };
      if (widget.data_edit["nama"] != "") {
        formData.addAll({"id_data": widget.data_edit["id_data"]});
      }

      if (data_pesanan.length == 0) {
        alert(
          context,
          "Opss",
          "Data Pesanan nakama belum di tambahkan",
          [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"))
          ],
        );
      } else {
        LoadingDialog(context, "Menyimpan data...");
        saveData(formData).then((value) {
          Navigator.pop(context);

          if (value == "terjadi_masalah" || value == "error") {
            ErrorDialog(context, value, simpan);
          } else {
            String status = jsonDecode(value)["status"];
            if (status == "data_saved") {
              alert(
                context,
                "Sukses",
                "Data berhasil di tambahkan",
                [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, "refresh");
                        Navigator.pop(context, "refresh");
                      },
                      child: Text("Ok"))
                ],
              );
            }
          }
        });
      }
    }
  }

  List data_pesanan = [];
  void _load() {
    nama.text = widget.data_edit["nama"];
    setState(() {
      jenis_kelamin = widget.data_edit["jenis_kelamin"];
      data_pesanan = jsonDecode(widget.data_edit["pesanan"]);
      jumlah_bayar.text = widget.data_edit["jumlah_bayar"];
      keterangan.text = widget.data_edit["keterangan"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.data_edit["nama"] != "") _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close)),
        title: Text(
          widget.data_edit["nama"] != "" ? "Edit Data" : "Tambah Data",
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tambah Data Nakama",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Height(height: 20),
                  Text("Nama Lengkap"),
                  TextFormField(
                    validator: (value) {
                      if (value == "") {
                        return "Tidak boleh kosong";
                      }
                    },
                    controller: nama,
                    decoration: InputDecoration(
                      hintText: "Misal : Yuka ",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Height(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Jenis Kelamin"),
                      Text(
                        jenis_kelamin,
                        style: TextStyle(color: Colors.black54),
                      )
                    ],
                  ),
                  Height(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                            onPressed: jenis_kelamin == "Laki-laki"
                                ? null
                                : () {
                                    setState(() {
                                      jenis_kelamin = "Laki-laki";
                                    });
                                  },
                            icon: Icon(Icons.man),
                            label: Text("Laki-laki")),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                            onPressed: jenis_kelamin == "Perempuan"
                                ? null
                                : () {
                                    setState(() {
                                      jenis_kelamin = "Perempuan";
                                    });
                                  },
                            icon: Icon(Icons.woman),
                            label: Text("Perempuan")),
                      )
                    ],
                  ),
                  Height(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Pesanan Nakama",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Pesanan_list();
                              },
                            ).then((value) {
                              if (value != null) {
                                print(value);
                                setState(() {
                                  data_pesanan.add(value);
                                });
                              }
                            });
                          },
                          child: Text("Tambah"))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "Pesanan",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                        Expanded(
                            child: Text(
                          "Jumlah",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        Expanded(
                            child: Text(
                          "Opsi",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                      ],
                    ),
                  ),
                  for (int i = 0; i < data_pesanan.length; i++)
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        width: 1,
                        color: Colors.black12,
                      ))),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                                data_pesanan[(data_pesanan.length - 1) - i]
                                    ["nama_pesanan"]),
                            flex: 2,
                          ),
                          Expanded(
                              child: Text(
                                  data_pesanan[(data_pesanan.length - 1) - i]
                                          ["jumlah"] +
                                      " Item")),
                          Expanded(
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      data_pesanan.removeAt(
                                          (data_pesanan.length - 1) - i);
                                    });
                                  },
                                  child: Text("Hapus"))),
                        ],
                      ),
                    ),
                  data_pesanan.length == 0
                      ? Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Icon(Icons.info),
                              Text("Data Kosong"),
                            ],
                          ),
                        )
                      : Container(),
                  Height(height: 20),
                  Text("Jumlah Pembayaran"),
                  TextFormField(
                    validator: (value) {
                      if (value == "") {
                        return "Tidak boleh kosong";
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: jumlah_bayar,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyTextInputFormatter(
                          locale: "id", decimalDigits: 0, symbol: "Rp. "),
                    ],
                    decoration: InputDecoration(
                      hintText: "Angka saja ",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Height(height: 20),
                  Text("Keterangan(Boleh Kosong)"),
                  TextFormField(
                    controller: keterangan,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Misal 2 org "),
                  ),
                  Height(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        simpan();
                      },
                      child: Text("Simpan"),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
