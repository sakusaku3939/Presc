import 'package:intl/intl.dart';
import 'package:presc/core/constants/app_constants.dart';

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
      return "${AppConstants.wordsPerMinute} words per minute";
    } else if (Intl.getCurrentLocale() == "ja") {
      return "1分${AppConstants.charactersPerMinute}文字";
    } else {
      return "${AppConstants.charactersPerMinute} characters per minute";
    }
  }
}
