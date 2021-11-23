// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static m0(name) => "タグ ${name}を削除しますか？この操作は元に戻せません。";

  static m1(count) => "${count}件のタグを削除";

  static m2(count) => "${count}件のタグを削除しました";

  static m3(minutes, second) => "${minutes}分${second}秒";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "addNewTag" : MessageLookupByLibrary.simpleMessage("新しいタグを追加"),
    "alertRemoveSelectTags" : MessageLookupByLibrary.simpleMessage("選択したタグを全て削除しますか？この操作は元に戻せません。"),
    "alertRemoveTag" : m0,
    "cancel" : MessageLookupByLibrary.simpleMessage("キャンセル"),
    "change" : MessageLookupByLibrary.simpleMessage("変更"),
    "changeTagName" : MessageLookupByLibrary.simpleMessage("タグ名を変更"),
    "characterCount" : MessageLookupByLibrary.simpleMessage("文字数"),
    "close" : MessageLookupByLibrary.simpleMessage("戻る"),
    "deleteAll" : MessageLookupByLibrary.simpleMessage("全て削除"),
    "doEmptyTrash" : MessageLookupByLibrary.simpleMessage("ごみ箱の中身を空にしますか？"),
    "edit" : MessageLookupByLibrary.simpleMessage("編集"),
    "editTag" : MessageLookupByLibrary.simpleMessage("タグの編集"),
    "estimatedReadingTime" : MessageLookupByLibrary.simpleMessage("読み上げ時間の目安（1分300文字）"),
    "lastModified" : MessageLookupByLibrary.simpleMessage("最終更新日時"),
    "moveTrash" : MessageLookupByLibrary.simpleMessage("ごみ箱に移動"),
    "newTagAdded" : MessageLookupByLibrary.simpleMessage("新しいタグを追加しました"),
    "next" : MessageLookupByLibrary.simpleMessage("次へ"),
    "noAdditionalText" : MessageLookupByLibrary.simpleMessage("追加のテキストはありません"),
    "noScriptYet" : MessageLookupByLibrary.simpleMessage("原稿がまだありません"),
    "noTitle" : MessageLookupByLibrary.simpleMessage("タイトルなし"),
    "onboardingCustomize" : MessageLookupByLibrary.simpleMessage("自由にカスタマイズ"),
    "onboardingCustomizeDescription" : MessageLookupByLibrary.simpleMessage("書式の向き（縦書き、横書き）や文字の色、フォントサイズ等は自由にカスタマイズ可能です。"),
    "onboardingManageScript" : MessageLookupByLibrary.simpleMessage("原稿を管理"),
    "onboardingManageScriptDescription" : MessageLookupByLibrary.simpleMessage("原稿を追加・編集・削除しましょう。作った原稿はタグを付けて整理することができます。"),
    "onboardingPlayScript" : MessageLookupByLibrary.simpleMessage("原稿を再生"),
    "onboardingPlayScriptDescription" : MessageLookupByLibrary.simpleMessage("出来た原稿を再生できます。音声認識により、どこまで話したかが一目で分かります。"),
    "onboardingStart" : MessageLookupByLibrary.simpleMessage("始める"),
    "onboardingWelcomePresc" : MessageLookupByLibrary.simpleMessage("Prescへようこそ"),
    "onboardingWelcomePrescDescription" : MessageLookupByLibrary.simpleMessage("Prescはプレゼンテーション、講演会、スピーチなどで使用できる原稿表示アプリです。"),
    "permanentlyDeleted" : MessageLookupByLibrary.simpleMessage("完全に削除"),
    "placeholderContent" : MessageLookupByLibrary.simpleMessage("ここに入力"),
    "placeholderTagName" : MessageLookupByLibrary.simpleMessage("ここに名前を入力"),
    "placeholderTitle" : MessageLookupByLibrary.simpleMessage("タイトル"),
    "remove" : MessageLookupByLibrary.simpleMessage("削除"),
    "removeSelectTags" : m1,
    "removeTag" : MessageLookupByLibrary.simpleMessage("タグを削除"),
    "restore" : MessageLookupByLibrary.simpleMessage("復元する"),
    "searchScript" : MessageLookupByLibrary.simpleMessage("原稿を検索"),
    "selectTagsRemoved" : m2,
    "setting" : MessageLookupByLibrary.simpleMessage("設定"),
    "skip" : MessageLookupByLibrary.simpleMessage("スキップ"),
    "tag" : MessageLookupByLibrary.simpleMessage("タグ"),
    "tagList" : MessageLookupByLibrary.simpleMessage("タグ一覧"),
    "tagRemoved" : MessageLookupByLibrary.simpleMessage("タグを削除しました"),
    "tagUpdated" : MessageLookupByLibrary.simpleMessage("タグを更新しました"),
    "time" : m3,
    "trash" : MessageLookupByLibrary.simpleMessage("ごみ箱"),
    "trashEmptied" : MessageLookupByLibrary.simpleMessage("ごみ箱を空にしました"),
    "trashEmpty" : MessageLookupByLibrary.simpleMessage("ごみ箱は空です"),
    "trashHint" : MessageLookupByLibrary.simpleMessage("ごみ箱の中身は7日後に完全に削除されます")
  };
}
