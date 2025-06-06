import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssetUtils {
  static Widget localizedImage(String name) {
    if (Intl.getCurrentLocale() != "ja") {
      final path = name.substring(14);
      return Image.asset("assets/images/en/$path");
    } else {
      return Image.asset(name);
    }
  }
}
