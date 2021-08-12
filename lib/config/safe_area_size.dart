import 'package:flutter/material.dart';

class SafeAreaSize {
  static SafeAreaSize _instance;
  static BuildContext _context;

  factory SafeAreaSize.of(BuildContext context) {
    if (_instance == null) {
    _instance = SafeAreaSize._privateConstructor();
    }
    _context = context;
    return _instance;
  }

  SafeAreaSize._privateConstructor();

  double get height {
    final logicalPixel = MediaQuery.of(_context).size.height;
    final appBarSize = AppBar().preferredSize.height;
    final padding = MediaQuery.of(_context).padding.top +
        MediaQuery.of(_context).padding.bottom;
    return logicalPixel - appBarSize - padding;
  }
}
