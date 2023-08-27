import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nakama_app/Componen/Height.dart';
import 'package:uuid/uuid.dart';

class Pesanan_list extends StatefulWidget {
  Pesanan_list({super.key});

  @override
  State<Pesanan_list> createState() => _Pesanan_listState();
}

class _Pesanan_listState extends State<Pesanan_list> {
  List menu = [
    "Nasi Ayam Teriyaki",
    "Nasi Parus Rica2",
    "Nasi Ayam Geprek",
    "Nasi Ayam Goreng Rempah",
    "Nasi Tuna suir Kemangi",
    "Ayam suir Kemangi",
    "Nasi Goreng Kampung",
    "Nasi Goreng Nasi goreng Special",
    "Mi titi",
    "Mi Seblak",
    "Mi Seblak Ori",
    "Indomie Goreng Telur",
    "Indomi Rebus Telur",
    // makanan 1
    "Pisang Goreng ORi",
    "Pisang Goreng coklat",
    "Pisang Goreng Coklat Keju",
    "Pisang Goreng Brown Sugar",
    "Cireng Encus",
    "Cireng Isi Ayam",
    "Cireng Balado",
    "Keju Aroma",
    "Ketang GOreng",
    "Ubi Goreng",
    "Sosis",
    "Bakso",
    "Keju",
    // minaman 1
    "Kopi sija",
    "Kopi Sija Jumbo",
    "Kopi Susu Sija",
    "Kopi Susu Sija Jumbo",
    "Thaitea",
    "Greentea",
    "Es Teh Manis",
    "Es Jeruk Peras",
    "Es Jeruk Nipis",
    "Teh Tarik",
    "Kopi Tarik",
    // drink 2
    "Signature Chocolate",
    "Neslo",
    "Kopi Susu Beruang",
    "Kpi Yakult",
    "Jus Mangga",
    "Jus Alpukat",
    "Jus Buah Naga",
  ];
  String search = "";
  String pilih = "";
  String jumlah = "0";

  void pJumlah(String pilihan) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Jumlah"),
      content: TextFormField(
        onChanged: (value) {
          jumlah = value;
        },
        keyboardType: TextInputType.number,
        autofocus: true,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Masukkan jumlah ",
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Batal")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, {
                'uuid': Uuid().v1().toString(),
                "nama_pesanan": pilihan,
                "jumlah": jumlah,
              });
            },
            child: Text("Simpan")),
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Height(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "Pilih Menu",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                    child: SizedBox(
                  height: 37,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        search = value.toLowerCase();
                      });
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(),
                        hintText: "Masukkan pencarian (" +
                            menu.length.toString() +
                            " Menu)"),
                  ),
                )),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Tutup"),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
              child: ListView.builder(
            itemCount: menu.length,
            itemBuilder: (context, index) {
              var getData = menu[index];
              return getData.toString().toLowerCase().contains(search)
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(17, 0, 0, 0)))),
                      child: ListTile(
                        onTap: () {
                          pJumlah(getData);
                        },
                        trailing: Icon(Icons.chevron_right),
                        title: Text(getData),
                      ),
                    )
                  : Container();
            },
          ))
        ],
      ),
    );
  }
}
