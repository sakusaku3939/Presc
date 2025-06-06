import 'package:intl/intl.dart';
import 'package:presc/core/constants/app_constants.dart';

class LanguageUtils {
  static bool isEnglish(String t) =>
      RegExp(r'^(?:[a-zA-Z]|\P{L})+$', unicode: true).hasMatch(t);

  static bool isLatinAlphabet(String t) => RegExp(r'^[ -~｡-ﾟ]+$').hasMatch(t);

  static String unit(String t) {
    if (Intl.getCurrentLocale() == "en") {
      return isEnglish(t) ? "words" : "characters";
    } else {
      return isEnglish(t) ? "（words）" : "";
    }
  }

  static bool isJapanese(String text) {
    final japaneseChars =
        RegExp(r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF\uFF66-\uFF9F]');
    final matches = japaneseChars.allMatches(text).length;
    final totalChars = text.replaceAll(RegExp(r'\s'), '').length;
    return totalChars > 0 && (matches / totalChars) > 0.3; // 30%以上が日本語文字
  }

  static String perMinute(String t) {
    if (isEnglish(t)) {
      return "${AppConstants.wordsPerMinute} words per minute";
    } else if (Intl.getCurrentLocale() == "ja") {
      return "1分${AppConstants.charactersPerMinute}文字";
    } else {
      return "${AppConstants.charactersPerMinute} characters per minute";
    }
  }
}
