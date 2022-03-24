import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:presc/model/hiragana.dart';

void main() {
  test("hiragana test", () async {
    dotenv.testLoad(fileInput: File(".env").readAsStringSync());
    final hiragana = Hiragana();
    final result = await hiragana.convert("吾輩は猫である。名前はまだ無い。");
    expect(result.hiragana, ['わがはいはねこである', '。', 'なまえは', 'まだ', 'ない', '。']);
  });
}
