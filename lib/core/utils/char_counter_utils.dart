import 'package:presc/core/utils/language_utils.dart';

class CharCounterUtils {
  static int includeSpace(String t) => t.replaceAll('\n', '').length;

  static int ignoreSpace(String t) =>
      t.replaceAll('\n', '').replaceAll(' ', '').length;

  static int word(String t) =>
      t.split(' ').where((e) => e.isNotEmpty).toList().length;

  static int lf(String t) => '\n'.allMatches(t).length;

  static int countLine(String t) => t.split('\n').where((e) => e == '').length;

  static int count(String t) {
    return LanguageUtils.isEnglish(t) ? word(t) : ignoreSpace(t);
  }
}
