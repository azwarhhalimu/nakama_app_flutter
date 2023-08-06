import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:nakama_app/Componen/Alert.dart';
import 'package:nakama_app/Componen/ErrorDialog.dart';
import 'package:nakama_app/Componen/Height.dart';
import 'package:nakama_app/Componen/LoadingDialog.dart';
import 'package:nakama_app/api/cekTiket.dart';
import 'package:nakama_app/api/proses_dataTiket.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vibration/vibration.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  bool status_senter = false;
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _cek_tiket(String id_tiket) {
    LoadingDialog(context, " Mengecek tiket ${id_tiket}...");
    cekTiket({"id_data": id_tiket}).then((value) {
      Vibration.vibrate(duration: 300, amplitude: 128);
      print(value);
      Navigator.pop(context);
      if (value == "terjadi_masalah" || value == "error") {
        ErrorDialog(context, value, () {
          controller?.resumeCamera();
        });
      } else {
        Map data = jsonDecode(value);

        print(data["status"]);
        if (data["status"] == "tiket_ketumu") {
          List pesanan = jsonDecode(data["data"]["pesanan"]);
          AlertDialog aler = AlertDialog(
            actions: data["data"]["status"] == "0"
                ? [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context); //close modal
                          _prosesPengambilan(id_tiket);
                        },
                        child: Text("Proses Pesanan")),
                    TextButton(
                        onPressed: () {
                          controller?.resumeCamera();
                          Navigator.pop(context);
                        },
                        child: Text("Batal"))
                  ]
                : [
                    TextButton(
                        onPressed: () {
                          controller?.resumeCamera();
                          Navigator.pop(context);
                        },
                        child: Text("OK")),
                  ],
            scrollable: true,
            title: Text("Data Ketemu"),
            content: Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Nama",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(" : "),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data["data"]["nama"],
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Jenis Kelamin",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(" : "),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data["data"]["jenis_kelamin"],
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Jumlah Bayar",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(" : "),
                      Expanded(
                        flex: 2,
                        child: Text(
                          data["data"]["jumlah_bayar"],
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Text(
                    data["data"]["status"] == "0"
                        ? "Pesanan belum di ambil"
                        : "Pesanan telah di ambil",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: data["data"]["status"] == "0"
                            ? Colors.green
                            : Colors.red),
                  ),
                  Divider(),
                  Text(
                    "Pesanan : ",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Height(height: 15),
                  for (int i = 0; i < pesanan.length; i++)
                    Text(
                      "${i + 1}. ${pesanan[i]["nama_pesanan"]} (${pesanan[i]["jumlah"]} item) ",
                      style: TextStyle(fontSize: 14),
                    ),
                ],
              ),
            ),
          );
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => aler,
          );
        } else if (data["status"] == "tiket_expire") {
          alert(
              context,
              "Tiket Expire",
              "Silahkan perintahkan penonton untuk melakukan refresh browser, untuk merequest tiket QR Code  baru!.\n\n Kemudian Scan Ulang.",
              [
                TextButton(
                    onPressed: () {
                      controller?.resumeCamera();
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ]);
        } else {
          alert(
              context, "Tiket palsu", "Tiket yang di gunakan tidak terdaftar", [
            TextButton(
                onPressed: () {
                  controller?.resumeCamera();
                },
                child: Text("Ok"))
          ]);
        }
      }
    });
  }

  void _prosesPengambilan(String id_tiket) {
    LoadingDialog(context, "Memproses...");
    proses_dataTiket({
      'id_data': id_tiket,
    }).then((value) {
      print(value);
      Navigator.pop(context);
      if (value == "terjadi_masalah" || value == "error") {
        ErrorDialog(context, value, () {
          Navigator.pop(context);
        });
      } else {
        Vibration.vibrate(duration: 300, amplitude: 30);
        String status = jsonDecode(value)["status"];
        if (status == "update_success") {
          alert(context, "Sukses", "Pesanan berhasil di proses", [
            TextButton(
                onPressed: () {
                  controller?.resumeCamera();
                  Navigator.pop(context);
                },
                child: Text("Selesai"))
          ]);
        }
      }
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        controller.pauseCamera();

        _cek_tiket(scanData.code!);
      }
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Column is also a layout widget. It takes a list of children and
      // arranges them vertically. By default, it sizes itself to fit its
      // children horizontally, and tries to be as tall as its parent.
      //
      // Column has various properties to control how it sizes itself and
      // how it positions its children. Here we use mainAxisAlignment to
      // center the children vertically; the main axis here is the vertical
      // axis because Columns are vertical (the cross axis would be
      // horizontal).
      //
      // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
      // action in the IDE, or press "p" in the console), to see the
      // wireframe for each widget.

      children: <Widget>[
        Container(
          color: Colors.red,
          height: double.infinity,
          width: double.infinity,
          child: Platform.isAndroid
              ? QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                )
              : Text("Scan"),
        ),
        Positioned(
            top: 20,
            right: 10,
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {
                      status_senter = controller?.getFlashStatus() as bool;
                    });
                  },
                  icon: Icon(
                    !status_senter
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Senter",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )),
        Positioned(
          top: (MediaQuery.of(context).size.height * 0.5) - 200,
          left: 0,
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GifView.asset(
                    "assets/scanner.gif",
                    width: 300,
                  ),
                  Text(
                    "Scan Tiket",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )),
        ),
      ],
    );
  }
}
