import 'package:nakama_app/enviroment.dart';
import "package:http/http.dart" as http;

Future<String> deleteData(Map formData) async {
  Uri uri = Uri.parse(baseUrl("site/hapus_data"));
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
