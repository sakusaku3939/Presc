import 'package:flutter/material.dart';

class DisplaySize {
  static _SafeAreaSize safeArea(BuildContext context) =>
      _SafeAreaSize.of(context);

  static bool get isLarge {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide > 600;
  }
}

class _SafeAreaSize {
  static _SafeAreaSize? _instance;
  static BuildContext? _context;

  _SafeAreaSize._();

  factory _SafeAreaSize.of(BuildContext context) {
    _context = context;
    _instance ??= _SafeAreaSize._();
    return _instance!;
  }

  double get height {
    final logicalPixel = MediaQuery.of(_context!).size.height;
    final appBarSize = AppBar().preferredSize.height;
    final padding = MediaQuery.of(_context!).padding.top +
        MediaQuery.of(_context!).padding.bottom;
    return logicalPixel - appBarSize - padding;
  }
}
