import 'package:intl/intl.dart';
import 'package:presc/config/init_config.dart';

class Language {
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

  static String perMinute(String t) {
    if (isEnglish(t)) {
      return "${InitConfig.wordsPerMinute} words per minute";
    } else if (Intl.getCurrentLocale() == "ja") {
      return "1分${InitConfig.charactersPerMinute}文字";
    } else {
      return "${InitConfig.charactersPerMinute} characters per minute";
    }
  }
}
