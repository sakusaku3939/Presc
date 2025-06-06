import 'package:presc/viewModel/playback_provider.dart';

class InitConfig {
  static const ngramNum = 5;
  static const ngramNumForAlphabet = 2;
  static const hiraganaNetworkTimeoutMs = 3000;
  static const hiraganaSlowNetworkThresholdMs = 2000; // n-gramに切り替える閾値
  static const scrollMode = ScrollMode.recognition;
  static const scrollHorizontal = true;
  static const showUndoRedo = true;
  static const undoDoubleTap = true;
  static const scrollSpeedMagnification = 1.0;
  static const fontSize = 20;
  static const tabletFontSize = 28;
  static const fontHeight = 2.4;
  static const charactersPerMinute = 320; // 1分間に読む文字数 (日本語)
  static const wordsPerMinute = 140; // 1分間に読む単語数 (英語)
}