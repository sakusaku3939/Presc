abstract class EnumHelper<T> {
  List<T> values();

  T valueOf(String value) {
    return values().firstWhere((item) {
      return name(item) == value;
    });
  }

  String name(T enumValue) {
    return enumValue.toString().split('.').last;
  }
}