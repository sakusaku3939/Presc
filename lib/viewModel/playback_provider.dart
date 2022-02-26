import 'package:flutter/material.dart';
import 'package:presc/config/color_config.dart';
import 'package:presc/config/display_size.dart';
import 'package:presc/config/init_config.dart';
import 'package:presc/model/utils/enum_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackProvider with ChangeNotifier {
  SharedPreferences _prefs;
  _ScrollModeHelper _modeHelper = _ScrollModeHelper();

  void Function() _onLoadListener;

  set onLoadListener(Function listener) {
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
  ScrollMode _scrollMode;

  ScrollMode get scrollMode =>
      _scrollMode ??
      _scrollModeFromVal(_prefs?.getString("scrollMode")) ??
      InitConfig.scrollMode;

  set scrollMode(ScrollMode mode) {
    _scrollMode = mode;
    _prefs?.setString("scrollMode", _modeHelper.name(mode));
    notifyListeners();
  }

  ScrollMode _scrollModeFromVal(String value) =>
      value != null ? _modeHelper.valueOf(value) : null;

  /*
  *  書式の向き（縦書き/横書き）
  */
  bool _scrollHorizontal;

  bool get scrollHorizontal =>
      _scrollHorizontal ??
      _prefs?.getBool("scrollHorizontal") ??
      InitConfig.scrollHorizontal;

  set scrollHorizontal(bool horizontal) {
    _scrollHorizontal = horizontal;
    _prefs?.setBool("scrollHorizontal", horizontal);
    notifyListeners();
  }

  /*
  *  元に戻す／やり直しボタン（表示/非表示）
  */
  bool _showUndoRedo;

  bool get showUndoRedo =>
      _showUndoRedo ??
      _prefs?.getBool("showUndoRedo") ??
      InitConfig.showUndoRedo;

  set showUndoRedo(bool show) {
    _showUndoRedo = show;
    _prefs?.setBool("showUndoRedo", show);
    notifyListeners();
  }

  /*
  *  原稿の再生速度
  */
  double _scrollSpeedMagnification;

  double get scrollSpeedMagnification =>
      _scrollSpeedMagnification ??
      _prefs?.getDouble("scrollSpeedMagnification") ??
      InitConfig.scrollSpeedMagnification;

  set scrollSpeedMagnification(double value) {
    _scrollSpeedMagnification = value;
    _prefs?.setDouble("scrollSpeedMagnification", value);
    notifyListeners();
  }

  /*
  *  フォントサイズ
  */
  final initFontSize =
      DisplaySize.isLarge ? InitConfig.tabletFontSize : InitConfig.fontSize;
  int _fontSize;

  int get fontSize => _fontSize ?? _prefs?.getInt("fontSize") ?? initFontSize;

  set fontSize(int size) {
    _fontSize = size;
    _prefs?.setInt("fontSize", size);
    notifyListeners();
  }

  /*
  *  フォントの高さ
  */
  double _fontHeight;

  double get fontHeight =>
      _fontHeight ?? _prefs?.getDouble("fontHeight") ?? InitConfig.fontHeight;

  set fontHeight(double height) {
    _fontHeight = height;
    _prefs?.setDouble("fontHeight", height);
    notifyListeners();
  }

  /*
  *  背景色
  */
  Color _backgroundColor;

  Color get backgroundColor =>
      _backgroundColor ??
      _colorFromVal(_prefs?.getInt("backgroundColor")) ??
      ColorConfig.playbackBackgroundColor;

  set backgroundColor(Color color) {
    _backgroundColor = color;
    _prefs?.setInt("backgroundColor", color.value);
    notifyListeners();
  }

  /*
  *  文字色
  */
  Color _textColor;

  Color get textColor =>
      _textColor ??
      _colorFromVal(_prefs?.getInt("textColor")) ??
      ColorConfig.playbackTextColor;

  set textColor(Color color) {
    _textColor = color;
    _prefs?.setInt("textColor", color.value);
    notifyListeners();
  }

  Color _colorFromVal(int value) => value != null ? Color(value) : null;

  PlaybackProvider() {
    Future(() async {
      _prefs = await SharedPreferences.getInstance();
      notifyListeners();
      if (_onLoadListener != null) _onLoadListener();
    });
  }
}

enum ScrollMode {
  manual,
  auto,
  recognition,
}

class _ScrollModeHelper extends EnumHelper<ScrollMode> {
  @override
  List<ScrollMode> values() => ScrollMode.values;
}
