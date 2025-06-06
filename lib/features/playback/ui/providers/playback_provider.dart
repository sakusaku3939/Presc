import 'package:flutter/material.dart';
import 'package:presc/core/constants/color_constants.dart';
import 'package:presc/core/utils/screen_utils.dart';
import 'package:presc/core/constants/app_constants.dart';
import 'package:presc/core/utils/enum_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  _ScrollModeHelper _modeHelper = _ScrollModeHelper();

  void Function()? _onLoadListener;

  set onLoadListener(void Function() listener) {
    if (_prefs == null) {
      _onLoadListener = listener;
    } else {
      listener();
    }
  }

  /*
  *  再生ボタン（再生/一時停止）
  */
  bool _playFabState = false;

  bool get playFabState => _playFabState;

  set playFabState(bool state) {
    _playFabState = state;
    notifyListeners();
  }

  /*
  *  再生モード（手動スクロール/自動スクロール/音声認識）
  */
  ScrollMode? _scrollMode;

  ScrollMode get scrollMode =>
      _scrollMode ??
      _scrollModeFromVal(_prefs?.getString("scrollMode")) ??
      AppConstants.scrollMode;

  set scrollMode(ScrollMode mode) {
    _scrollMode = mode;
    _prefs?.setString("scrollMode", _modeHelper.name(mode));
    notifyListeners();
  }

  ScrollMode? _scrollModeFromVal(String? value) =>
      value != null ? _modeHelper.valueOf(value) : null;

  /*
  *  書式の向き（縦書き/横書き）
  */
  bool? _scrollHorizontal;

  bool get scrollHorizontal =>
      _scrollHorizontal ??
      _prefs?.getBool("scrollHorizontal") ??
      AppConstants.scrollHorizontal;

  set scrollHorizontal(bool horizontal) {
    _scrollHorizontal = horizontal;
    _prefs?.setBool("scrollHorizontal", horizontal);
    notifyListeners();
  }

  /*
  *  元に戻す／やり直しボタン（表示/非表示）
  */
  bool? _showUndoRedo;

  bool get showUndoRedo =>
      _showUndoRedo ??
      _prefs?.getBool("showUndoRedo") ??
      AppConstants.showUndoRedo;

  set showUndoRedo(bool show) {
    _showUndoRedo = show;
    _prefs?.setBool("showUndoRedo", show);
    notifyListeners();
  }

  /*
  *  2回タップで元に戻す（ON/OFF）
  */
  bool? _undoDoubleTap;

  bool get undoDoubleTap =>
      _undoDoubleTap ??
      _prefs?.getBool("undoDoubleTap") ??
      AppConstants.undoDoubleTap;

  set undoDoubleTap(bool tap) {
    _undoDoubleTap = tap;
    _prefs?.setBool("undoDoubleTap", tap);
    notifyListeners();
  }

  /*
  *  原稿の再生速度
  */
  double? _scrollSpeedMagnification;

  double get scrollSpeedMagnification =>
      _scrollSpeedMagnification ??
      _prefs?.getDouble("scrollSpeedMagnification") ??
      AppConstants.scrollSpeedMagnification;

  set scrollSpeedMagnification(double value) {
    _scrollSpeedMagnification = value;
    _prefs?.setDouble("scrollSpeedMagnification", value);
    notifyListeners();
  }

  /*
  *  フォントサイズ
  */
  int? _fontSize;
  final initFontSize =
      ScreenUtils.isTablet ? AppConstants.tabletFontSize : AppConstants.fontSize;

  int get fontSize => _fontSize ?? _prefs?.getInt("fontSize") ?? initFontSize;

  set fontSize(int size) {
    _fontSize = size;
    _prefs?.setInt("fontSize", size);
    notifyListeners();
  }

  /*
  *  フォントの高さ
  */
  double? _fontHeight;

  double get fontHeight =>
      _fontHeight ?? _prefs?.getDouble("fontHeight") ?? AppConstants.fontHeight;

  set fontHeight(double height) {
    _fontHeight = height;
    _prefs?.setDouble("fontHeight", height);
    notifyListeners();
  }

  /*
  *  背景色
  */
  Color? _backgroundColor;

  Color get backgroundColor =>
      _backgroundColor ??
      _colorFromVal(_prefs?.getInt("backgroundColor")) ??
      ColorConstants.playbackBackgroundColor;

  set backgroundColor(Color color) {
    _backgroundColor = color;
    _prefs?.setInt("backgroundColor", color.value);
    notifyListeners();
  }

  /*
  *  文字色
  */
  Color? _textColor;

  Color get textColor =>
      _textColor ??
      _colorFromVal(_prefs?.getInt("textColor")) ??
      ColorConstants.playbackTextColor;

  set textColor(Color color) {
    _textColor = color;
    _prefs?.setInt("textColor", color.value);
    notifyListeners();
  }

  Color? _colorFromVal(int? value) => value != null ? Color(value) : null;

  PlaybackProvider() {
    Future(() async {
      _prefs = await SharedPreferences.getInstance();
      notifyListeners();
      if (_onLoadListener != null) _onLoadListener!();
    });
  }
}

enum ScrollMode {
  manual,
  auto,
  recognition,
}

class _ScrollModeHelper extends EnumUtils<ScrollMode> {
  @override
  List<ScrollMode> values() => ScrollMode.values;
}
