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
    "Cappucino Hot",
    "Cappucino Cold",
    "Amiricatno Hot",
    "Amiricatno Cold",
    "Kopi susu Lacafe Hot",
    "Hazelnut Latte Cold",
    "Caramel Macchianto Hot",
    "Caramel Macchianto Cold",
    "Vanila Latte Hot",
    "Caramel Latte Hot",
    "Cofee Beer",
    "Air Mineral Aqua",
    "Red Valvet Cold",
    "Taro Cold",
    "Lemon Tea Cold",
    "Thai Tea Cold",
    "Chocolate Cold",
    "Chocolate Hot",
    "Chocolate Hazelnut Cold",
    "Chocolate Caramel Cold",
    "Chocolate Bannana Cold",
    "Musa Velutina",
    "French Fries",
    "Pisang Nugget",
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
          hintText: "Masukkan jumlah",
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
      height: MediaQuery.of(context).size.height * .7,
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
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(),
                        hintText: "Masukkan pencarian"),
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
