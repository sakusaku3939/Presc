/// バックアップファイル情報を表すクラス
class BackupFileInfo {
  final String filePath;
  final String fileName;
  final DateTime createdAt;
  final int memoCount;
  final int fileSize;

  BackupFileInfo({
    required this.filePath,
    required this.fileName,
    required this.createdAt,
    required this.memoCount,
    required this.fileSize,
  });

  String get formattedSize {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024)
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

/// インポート結果を表すクラス
class ImportResult {
  final int totalCount;
  final int addedCount;
  final int skippedCount;
  final List<String> errors;
  final String? backupDate;

  ImportResult({
    required this.totalCount,
    required this.addedCount,
    required this.skippedCount,
    required this.errors,
    this.backupDate,
  });

  bool get hasErrors => errors.isNotEmpty;

  bool get isSuccessful =>
      addedCount > 0 || (totalCount == skippedCount && errors.isEmpty);
}
