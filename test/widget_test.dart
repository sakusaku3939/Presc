import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:presc/features/playback/data/hiragana_service.dart';

void main() {
  setUp(() {
    dotenv.loadFromString(envString: 'YAHOO_APP_ID=test-app-id');
  });

  test(
    'furigana conversion groups characters and preserves punctuation',
    () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/FuriganaService/V2/furigana');
        expect(request.headers['User-Agent'], 'Yahoo AppID: test-app-id');
        expect(jsonDecode(request.body)['params']['q'], '吾輩は猫。名前は');
        return http.Response(
          jsonEncode({
            'result': {
              'word': [
                {'surface': '吾輩', 'furigana': 'わがはい'},
                {'surface': 'は'},
                {'surface': '猫', 'furigana': 'ねこ'},
                {'surface': '。'},
                {'surface': '名前', 'furigana': 'なまえ'},
                {'surface': 'は'},
              ],
            },
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });
      addTearDown(client.close);

      final result = await http.runWithClient(
        () => HiraganaService().convert('吾輩は猫。名前は'),
        () => client,
      );

      expect(result?.origin, ['吾輩は猫', '。', '名前は']);
      expect(result?.hiragana, ['わがはいはねこ', '。', 'なまえは']);
    },
  );

  test(
    'furigana conversion returns null when the API rejects a request',
    () async {
      final client = MockClient((_) async => http.Response('Unavailable', 503));
      addTearDown(client.close);
      final result = await http.runWithClient(
        () => HiraganaService().convert('原稿'),
        () => client,
      );
      expect(result, isNull);
    },
  );
}
