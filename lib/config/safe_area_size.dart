import 'package:flutter/material.dart';

class SafeAreaSize {
  static SafeAreaSize _instance;
  static BuildContext _context;

  SafeAreaSize._();

  factory SafeAreaSize.of(BuildContext context) {
    _context = context;
    _instance ??= SafeAreaSize._();
    return _instance;
  }

  double get height {
    final logicalPixel = MediaQuery.of(_context).size.height;
    final appBarSize = AppBar().preferredSize.height;
    final padding = MediaQuery.of(_context).padding.top +
        MediaQuery.of(_context).padding.bottom;
    return logicalPixel - appBarSize - padding;
  }
}
