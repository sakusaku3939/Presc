import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:presc/core/constants/punctuation_constants.dart';

class Hiragana {
  /*
  *  Convert by Yahoo! JAPAN ルビ振りv2
  *  https://developer.yahoo.co.jp/webapi/jlp/furigana/v2/furigana.html
  *
  *  Web Services by Yahoo! JAPAN （https://developer.yahoo.co.jp/sitemap/）
  * */
  Future<HiraganaResult?> convert(String text) async {
    final url = "https://jlp.yahooapis.jp/FuriganaService/V2/furigana";
    final http.Response res = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "User-Agent": "Yahoo AppID: ${dotenv.env["YAHOO_APP_ID"]}",
      },
      body: json.encode({
        "id": "1234-1",
        "jsonrpc": "2.0",
        "method": "jlp.furiganaservice.furigana",
        "params": {"q": text, "grade": 1}
      }),
    );

    if (res.statusCode == 200) {
      final result = HiraganaResult();
      Map<String, dynamic> body = json.decode(res.body);
      List<dynamic> word = body["result"]["word"];

      for (int i = 0; i < word.length; i++) {
        String origin = word[i]["surface"];
        String? hiragana = word[i]["furigana"];

        final isEmpty = result.origin.isEmpty;
        final isLong = origin.length > 1;
        final isPunctuation = PunctuationConstants.list.contains(origin);

        if (isEmpty || isLong || isPunctuation) {
          result.origin.add(origin);
          result.hiragana.add(hiragana ?? origin);
        } else {
          result.origin.last += origin;
          result.hiragana.last += hiragana ?? origin;
        }
      }
      return result;
    } else {
      print("Failed to post hiragana ${res.statusCode}: ${res.body}");
      return null;
    }
  }
}

class HiraganaResult {
  final List<String> origin = [];
  final List<String> hiragana = [];
}
