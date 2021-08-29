class CharCounter {
  static int includeSpace(String text) => text.replaceAll('\n', '').length;

  static int ignoreSpace(String text) =>
      text.replaceAll('\n', '').replaceAll(' ', '').length;

  static int lf(String text) => '\n'.allMatches(text).length;
}
