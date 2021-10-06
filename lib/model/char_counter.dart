class CharCounter {
  static int includeSpace(String text) => text.replaceAll('\n', '').length;

  static int ignoreSpace(String text) =>
      text.replaceAll('\n', '').replaceAll(' ', '').length;

  static int lf(String text) => '\n'.allMatches(text).length;

  static int countLine(String text) =>
      text.split('\n').where((e) => e == '').length;
}
