import 'package:presc/core/constants/app_constants.dart';
import 'package:presc/core/constants/punctuation_constants.dart';
import 'package:presc/features/playback/data/hiragana_service.dart';
import 'package:presc/core/utils/language_utils.dart';

class TextMatchingAlgorithm {
  final _hiragana = HiraganaService();

  // ネットワーク速度に応じてマッチング方法を動的に切り替える
  bool _useSlowNetworkMode = false;

  /// ネットワークモードをリセット
  void resetNetworkMode() {
    _useSlowNetworkMode = false;
  }

  /// 音声認識されたテキストと未認識テキストから、テキスト位置を計算する
  Future<TextPosition> calculateTextPosition(
    String recognizedText,
    String unrecognizedText,
  ) async {
    final rangeText = _prepareRangeText(recognizedText, unrecognizedText);
    return await _calculateTextPosition(recognizedText, rangeText);
  }

  /// 範囲テキストを準備する
  String _prepareRangeText(String recognizedText, String unrecognizedText) {
    final isLatinAlphabet = LanguageUtils.isLatinAlphabet(recognizedText);
    final range = !isLatinAlphabet ? 120 : 240;

    return unrecognizedText.length > range
        ? unrecognizedText.substring(0, range)
        : unrecognizedText;
  }

  /// テキスト位置を計算する
  Future<TextPosition> _calculateTextPosition(
    String recognizedText,
    String rangeText,
  ) async {
    final isLatinAlphabet = LanguageUtils.isLatinAlphabet(recognizedText);

    if (isLatinAlphabet) {
      return _calculateLatinTextPosition(recognizedText, rangeText);
    } else {
      return await _calculateJapaneseTextPosition(recognizedText, rangeText);
    }
  }

  /// ラテン文字のテキスト位置を計算する
  TextPosition _calculateLatinTextPosition(
    String recognizedText,
    String rangeText,
  ) {
    final words = recognizedText.split(" ").where((w) => w.isNotEmpty).toList();
    final filteredText = rangeText.toLowerCase().replaceAllMapped(
          RegExp(r'[^\w\s]'), // 英数字とスペース以外の文字を除外
          (match) => " ",
        );
    final splitRangeWords = filteredText.split(" ");

    // bigramを使用してマッチングする
    if (words.length >= 2) {
      final bigrams = List.generate(
        words.length - 1,
        (i) => "${words[i]} ${words[i + 1]}".toLowerCase(),
      );

      // 連続する2語の位置を逆順で検索する
      int foundIndex = -1;
      for (int bigramIdx = bigrams.length - 1; bigramIdx >= 0; bigramIdx--) {
        final bigram = bigrams[bigramIdx];
        final bigramWords = bigram.split(" ");

        for (int i = 0; i < splitRangeWords.length - 1; i++) {
          if (splitRangeWords[i] == bigramWords[0] &&
              splitRangeWords[i + 1] == bigramWords[1]) {
            // 最初に見つかった位置を記録
            foundIndex = i;
            break;
          }
        }

        // マッチしたら終了
        if (foundIndex != -1) {
          break;
        }
      }

      if (foundIndex != -1) {
        final textLen =
            splitRangeWords.sublist(0, foundIndex).join().length + foundIndex;
        final matchedWordLength =
            "${splitRangeWords[foundIndex]} ${splitRangeWords[foundIndex + 1]}"
                .length;
        return TextPosition(textLen, matchedWordLength);
      }
    }

    return TextPosition.notFound();
  }

  /// 日本語のテキスト位置を計算する
  Future<TextPosition> _calculateJapaneseTextPosition(
    String recognizedText,
    String rangeText,
  ) async {
    // 音声認識された文章と、現在の場所から120文字以内の文章をひらがなに変換
    // ただし、ネットワーク速度に応じてn-gramにフォールバックする
    final res = await Future.wait([
      _convertWithNetworkFallback(recognizedText),
      _convertWithNetworkFallback(rangeText),
    ]);
    final recognizedTextResult = res.first;
    final rangeTextResult = res.last;

    if (recognizedTextResult != null && rangeTextResult != null) {
      return _calculateHiraganaTextPosition(
          recognizedTextResult, rangeTextResult);
    } else {
      return _calculateNgramTextPosition(recognizedText, rangeText);
    }
  }

  /// ひらがな変換を行う
  /// ネットワーク速度が遅い場合はn-gramにフォールバックする
  Future<HiraganaResult?> _convertWithNetworkFallback(String text) async {
    if (_useSlowNetworkMode) {
      return null;
    }

    try {
      final stopwatch = Stopwatch()..start();

      final result = await Future.any([
        _hiragana.convert(text),
        Future.delayed(
          Duration(milliseconds: AppConstants.hiraganaNetworkTimeoutMs),
          () => null,
        ),
      ]);

      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds;

      // ネットワーク速度が閾値を超えた場合はn-gramモードに切り替える
      if (elapsedMs > AppConstants.hiraganaSlowNetworkThresholdMs ||
          result == null) {
        _useSlowNetworkMode = true;
        print('ネットワークが遅いため、n-gramモードに切り替えました (${elapsedMs}ms)');
        return null;
      }

      return result;
    } catch (e) {
      print('ひらがな変換でエラーが発生: $e');
      _useSlowNetworkMode = true;
      return null;
    }
  }

  /// ひらがな変換結果からテキスト位置を計算する
  TextPosition _calculateHiraganaTextPosition(
    HiraganaResult recognizedTextResult,
    HiraganaResult rangeTextResult,
  ) {
    // 形態素解析されたひらがな文章から、最初に一致したindexを取得
    final hiraganaFirstIndex = _findHiraganaFirstIndex(
      recognizedText: recognizedTextResult.hiragana,
      rangeText: rangeTextResult.hiragana,
    );

    if (hiraganaFirstIndex != -1) {
      final origin = rangeTextResult.origin;
      final rangeOrigin = origin.sublist(0, hiraganaFirstIndex);
      final textLen = rangeOrigin.join().length;
      final matchedWordLength = origin[hiraganaFirstIndex].length;
      return TextPosition(textLen, matchedWordLength);
    } else {
      return TextPosition.notFound();
    }
  }

  /// N-gramを使用してテキスト位置を計算する
  TextPosition _calculateNgramTextPosition(
    String recognizedText,
    String rangeText,
  ) {
    // ひらがなへの変換に失敗した場合（タイムアウト含む）はN-gramで分割
    print('n-gramモードで処理中...');
    final N = AppConstants.ngramNum;
    final textLen = _findTextIndex(
      rangeText.toLowerCase(),
      splitWords: _charNgram(recognizedText, N),
    );
    return TextPosition(textLen, N);
  }

  /// 文字列のN-gramを生成する
  List<String> _charNgram(String target, int n) => List.generate(
        target.length - n + 1,
        (i) => target.substring(i, i + n),
      );

  /// テキストインデックスを検索する
  int _findTextIndex(
    dynamic text, {
    required List<String> splitWords,
  }) {
    int foundIndex = -1;

    // 文字列を逆順に検索し、最初に見つかった位置を取得する
    for (int i = splitWords.length - 1; i >= 0; i--) {
      final word = splitWords[i];
      final index = text.indexOf(word.toLowerCase().trim());
      if (index != -1) {
        foundIndex = index;
        break;
      }
    }

    return foundIndex;
  }

  /// ひらがなテキストから最初にマッチするインデックスを検索する
  int _findHiraganaFirstIndex({
    required List<String> recognizedText,
    required List<String> rangeText,
  }) {
    int foundIndex = -1;

    // 文字列を逆順に検索し、最初に見つかった位置を取得する
    for (int i = recognizedText.length - 1; i >= 0; i--) {
      final word = recognizedText[i].trim();

      for (int j = 0; j < rangeText.length; j++) {
        if (rangeText[j].trim() == word) {
          final isPunctuation = PunctuationConstants.list.contains(word);
          if (!isPunctuation) {
            foundIndex = j;
            break;
          }
        }
      }

      if (foundIndex != -1) {
        break;
      }
    }

    return foundIndex;
  }
}

/// テキスト位置情報を表すクラス
class TextPosition {
  final int textLen;
  final int matchedWordLength;

  const TextPosition(this.textLen, this.matchedWordLength);

  const TextPosition.notFound()
      : textLen = -1,
        matchedWordLength = 0;

  bool get isFound => textLen != -1;
}
