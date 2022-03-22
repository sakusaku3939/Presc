import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Hiragana {
  /*
  *  Convert by gooラボ ひらがな化API
  *  https://labs.goo.ne.jp/api/jp/hiragana-translation/
  * */
  Future<String> convert(String text) async {
    final url = Uri.parse("https://labs.goo.ne.jp/api/hiragana");
    final http.Response res = await http.post(
      url,
      headers: {"content-type": "application/json"},
      body: json.encode({
        "app_id": dotenv.env["GOO_LABS_ID"],
        "sentence": text,
        "output_type": "hiragana",
      }),
    );
    if (res.statusCode == 200) {
      Map<String, dynamic> result = json.decode(res.body);
      return result["converted"].toString();
    } else {
      print("Failed to post hiragana: ${res.statusCode}");
      return null;
    }
  }
}
