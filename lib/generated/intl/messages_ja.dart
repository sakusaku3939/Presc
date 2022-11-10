// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static String m0(name) => "タグ ${name}を削除しますか？この操作は元に戻せません。";

  static String m1(title) => "${title}を完全に削除しますか？";

  static String m2(error) => "エラー: ${error}";

  static String m3(count) => "${count}件のタグを削除";

  static String m4(count) => "${count}件のタグを削除しました";

  static String m5(minutes, second) => "${minutes}分${second}秒";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutApp": MessageLookupByLibrary.simpleMessage("このアプリについて"),
        "addNewTag": MessageLookupByLibrary.simpleMessage("新しいタグを追加"),
        "alertRemoveSelectTags": MessageLookupByLibrary.simpleMessage(
            "選択したタグを全て削除しますか？この操作は元に戻せません。"),
        "alertRemoveTag": m0,
        "autoScroll": MessageLookupByLibrary.simpleMessage("自動スクロール"),
        "autoScrollDescription":
            MessageLookupByLibrary.simpleMessage("一定の速度でスクロールします"),
        "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "change": MessageLookupByLibrary.simpleMessage("変更"),
        "changeTagName": MessageLookupByLibrary.simpleMessage("タグ名を変更"),
        "characterCount": MessageLookupByLibrary.simpleMessage("文字数"),
        "close": MessageLookupByLibrary.simpleMessage("戻る"),
        "delete": MessageLookupByLibrary.simpleMessage("削除"),
        "deleteAll": MessageLookupByLibrary.simpleMessage("全て削除"),
        "deletePermanently": MessageLookupByLibrary.simpleMessage("完全に削除"),
        "doDeletePermanently": m1,
        "doEmptyTrash": MessageLookupByLibrary.simpleMessage("ごみ箱の中身を空にしますか？"),
        "done": MessageLookupByLibrary.simpleMessage("完了"),
        "edit": MessageLookupByLibrary.simpleMessage("編集"),
        "editTag": MessageLookupByLibrary.simpleMessage("タグの編集"),
        "emptyScriptDeleted":
            MessageLookupByLibrary.simpleMessage("空の原稿を削除しました"),
        "error": m2,
        "estimatedReadingTime":
            MessageLookupByLibrary.simpleMessage("読み上げ時間の目安（1分320文字）"),
        "formatOrientation": MessageLookupByLibrary.simpleMessage("書式の向き"),
        "hide": MessageLookupByLibrary.simpleMessage("非表示"),
        "hint": MessageLookupByLibrary.simpleMessage("ヒント"),
        "hintContent": MessageLookupByLibrary.simpleMessage("再生中に音を鳴らしたくない場合"),
        "horizontal": MessageLookupByLibrary.simpleMessage("横書き"),
        "lastModified": MessageLookupByLibrary.simpleMessage("最終更新日時"),
        "manualScroll": MessageLookupByLibrary.simpleMessage("手動スクロール"),
        "manualScrollDescription":
            MessageLookupByLibrary.simpleMessage("スクロールを行いません"),
        "micBusy": MessageLookupByLibrary.simpleMessage("マイクがビジー状態です"),
        "moveTrash": MessageLookupByLibrary.simpleMessage("ごみ箱に移動"),
        "networkError":
            MessageLookupByLibrary.simpleMessage("ネットワークエラーが発生しました"),
        "newTagAdded": MessageLookupByLibrary.simpleMessage("新しいタグを追加しました"),
        "next": MessageLookupByLibrary.simpleMessage("次へ"),
        "noAdditionalText":
            MessageLookupByLibrary.simpleMessage("追加のテキストはありません"),
        "noScriptYet": MessageLookupByLibrary.simpleMessage("原稿がまだありません"),
        "noTitle": MessageLookupByLibrary.simpleMessage("タイトルなし"),
        "notShowAgain": MessageLookupByLibrary.simpleMessage("今後は表示しない"),
        "onboardingCustomize":
            MessageLookupByLibrary.simpleMessage("自由にカスタマイズ"),
        "onboardingCustomizeDescription": MessageLookupByLibrary.simpleMessage(
            "書式の向き（縦書き、横書き）や文字の色、フォントサイズ等は自由にカスタマイズ可能です。"),
        "onboardingManageScript": MessageLookupByLibrary.simpleMessage("原稿を管理"),
        "onboardingManageScriptDescription":
            MessageLookupByLibrary.simpleMessage(
                "原稿を追加・編集・削除しましょう。作った原稿はタグを付けて整理することができます。"),
        "onboardingPlayScript": MessageLookupByLibrary.simpleMessage("原稿を再生"),
        "onboardingPlayScriptDescription": MessageLookupByLibrary.simpleMessage(
            "出来た原稿を再生できます。音声認識により、どこまで話したかが一目で分かります。"),
        "onboardingStart": MessageLookupByLibrary.simpleMessage("始める"),
        "onboardingWelcomePresc":
            MessageLookupByLibrary.simpleMessage("Prescへようこそ"),
        "onboardingWelcomePrescDescription":
            MessageLookupByLibrary.simpleMessage(
                "Prescはプレゼンテーション、講演会、スピーチなどで使用できる原稿表示アプリです。"),
        "openSetting": MessageLookupByLibrary.simpleMessage("設定を開く"),
        "ossLicence": MessageLookupByLibrary.simpleMessage("オープンソースライセンス"),
        "permanentlyDeleted": MessageLookupByLibrary.simpleMessage("完全に削除しました"),
        "placeholderContent": MessageLookupByLibrary.simpleMessage("ここに入力"),
        "placeholderTagName": MessageLookupByLibrary.simpleMessage("ここに名前を入力"),
        "placeholderTitle": MessageLookupByLibrary.simpleMessage("タイトル"),
        "playMode": MessageLookupByLibrary.simpleMessage("再生モード"),
        "playSetting": MessageLookupByLibrary.simpleMessage("再生設定"),
        "playSpeed": MessageLookupByLibrary.simpleMessage("再生速度"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
        "remove": MessageLookupByLibrary.simpleMessage("削除"),
        "removeSelectTags": m3,
        "removeTag": MessageLookupByLibrary.simpleMessage("タグを削除"),
        "requirePermission":
            MessageLookupByLibrary.simpleMessage("音声認識を行うにはマイクの許可が必要です"),
        "resetInitValue": MessageLookupByLibrary.simpleMessage("初期値に戻す"),
        "restore": MessageLookupByLibrary.simpleMessage("復元する"),
        "searchScript": MessageLookupByLibrary.simpleMessage("原稿を検索"),
        "selectTagsRemoved": m4,
        "sendFeedback": MessageLookupByLibrary.simpleMessage("フィードバックを送る"),
        "setting": MessageLookupByLibrary.simpleMessage("設定"),
        "show": MessageLookupByLibrary.simpleMessage("表示"),
        "skip": MessageLookupByLibrary.simpleMessage("スキップ"),
        "speechRecognition": MessageLookupByLibrary.simpleMessage("音声認識"),
        "speechRecognitionDescription":
            MessageLookupByLibrary.simpleMessage("認識した文字分だけスクロールします"),
        "tag": MessageLookupByLibrary.simpleMessage("タグ"),
        "tagList": MessageLookupByLibrary.simpleMessage("タグ一覧"),
        "tagRemoved": MessageLookupByLibrary.simpleMessage("タグを削除しました"),
        "tagUpdated": MessageLookupByLibrary.simpleMessage("タグを更新しました"),
        "time": m5,
        "trash": MessageLookupByLibrary.simpleMessage("ごみ箱"),
        "trashEmptied": MessageLookupByLibrary.simpleMessage("ごみ箱を空にしました"),
        "trashEmpty": MessageLookupByLibrary.simpleMessage("ごみ箱は空です"),
        "trashHint":
            MessageLookupByLibrary.simpleMessage("ごみ箱の中身は7日後に完全に削除されます"),
        "trashMoved": MessageLookupByLibrary.simpleMessage("ごみ箱に移動しました"),
        "trashRestored": MessageLookupByLibrary.simpleMessage("ごみ箱から復元しました"),
        "undo": MessageLookupByLibrary.simpleMessage("元に戻す"),
        "undoDoubleTap": MessageLookupByLibrary.simpleMessage("2回タップで元に戻す"),
        "undoRedoButton": MessageLookupByLibrary.simpleMessage("元に戻す／やり直しボタン"),
        "vertical": MessageLookupByLibrary.simpleMessage("縦書き")
      };
}
