import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:presc/features/manuscript/data/manuscript_repository.dart';
import 'package:presc/features/manuscript/data/models/backup_file_info.dart';
import 'package:presc/features/manuscript/data/models/database_table.dart';

class LocalBackupService {
  static final _manuscript = ManuscriptRepository();

  /// 外部ストレージにバックアップをエクスポート
  static Future<String?> exportBackupToExternal() async {
    try {
      // バックアップデータを作成
      final normalMemos = await _manuscript.getAllScript(trash: false);
      List<MemoTable> allMemos = normalMemos;

      final backupData = {
        'version': '1.0',
        'app_name': 'Presc',
        'created_at': DateTime.now().toIso8601String(),
        'memo_count': allMemos.length,
        'memos': allMemos.map((memo) => memo.toMap()).toList(),
      };

      final jsonString = json.encode(backupData);
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .replaceAll('.', '-');
      final fileName = 'presc_backup_$timestamp.json';

      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'バックアップファイルを保存',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: utf8.encode(jsonString),
      );

      return result;
    } catch (e) {
      throw Exception('バックアップのエクスポートに失敗しました: $e');
    }
  }

  /// バックアップファイルからデータを復元
  static Future<ImportResult?> importBackupData() async {
    try {
      // バックアップファイルを選択
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) {
        // ユーザーがファイル選択をキャンセルした場合
        return null;
      }

      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final backupData = json.decode(jsonString);

      // バックアップデータの検証
      if (backupData['memos'] == null) {
        return ImportResult(
          totalCount: 0,
          addedCount: 0,
          skippedCount: 0,
          errors: ['無効なバックアップファイルです'],
        );
      }

      final importMemos = List<Map<String, dynamic>>.from(backupData['memos']);

      // 既存の原稿を取得
      final existingScripts = await _manuscript.getAllScript(trash: false);
      final existingTrashScripts = await _manuscript.getAllScript(trash: true);
      final allExistingScripts = [...existingScripts, ...existingTrashScripts];

      // 重複チェックを行う（title + content + dateで判定）
      final existingScriptSignatures = allExistingScripts.map((memo) {
        return '${memo.title}_${memo.content}_${memo.date.toIso8601String()}';
      }).toSet();

      int addedCount = 0;
      int skippedCount = 0;
      List<String> errors = [];

      // インポートメモを追加
      for (final memoData in importMemos) {
        try {
          final memo = MemoTable.fromMap(memoData);
          final signature =
              '${memo.title}_${memo.content}_${memo.date.toIso8601String()}';

          // 重複チェック
          if (existingScriptSignatures.contains(signature)) {
            skippedCount++;
            continue;
          }

          await _manuscript.addScript(
            title: memo.title ?? "",
            content: memo.content ?? "",
            date: memo.date,
          );
          addedCount++;
        } catch (e) {
          errors.add('原稿の追加に失敗しました: $e');
        }
      }

      return ImportResult(
        totalCount: importMemos.length,
        addedCount: addedCount,
        skippedCount: skippedCount,
        errors: errors,
        backupDate: backupData['created_at'],
      );
    } catch (e) {
      return ImportResult(
        totalCount: 0,
        addedCount: 0,
        skippedCount: 0,
        errors: ['バックアップの復元に失敗しました: $e'],
      );
    }
  }
}
