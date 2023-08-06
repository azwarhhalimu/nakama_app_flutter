import 'package:flutter/material.dart';
import 'package:nakama_app/Componen/Height.dart';

class LoadingList extends StatelessWidget {
  LoadingList({super.key, required this.jumlah});
  int jumlah;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black12;
    return ListView.builder(
      itemCount: jumlah,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: color,
              ),
              width: 30,
              height: 30,
            ),
            trailing: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: color,
              ),
              width: 20,
              height: 20,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: color,
                  ),
                  width: double.infinity,
                  height: 10,
                ),
                Height(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: color,
                  ),
                  width: double.infinity,
                  height: 10,
                ),
                Height(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: color,
                  ),
                  width: 100,
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
