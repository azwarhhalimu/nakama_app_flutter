import 'package:nakama_app/enviroment.dart';
import "package:http/http.dart" as http;

Future<String> cekTiket(Map formData) async {
  Uri uri = Uri.parse(baseUrl("site/cek_tiket"));
  try {
    var respon = await http.post(uri, body: formData);
    print(respon.body);
    if (respon.statusCode == 200) {
      return respon.body;
    }
  } catch (e) {
    print(e);
    return "error";
  }
  return "terjadi_masalah";
}
