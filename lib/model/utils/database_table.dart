import 'package:flutter/material.dart';

abstract class DatabaseTable {
  DatabaseTable(this.tableName, {@required this.id});

  final String tableName;
  final int id;

  Map<String, dynamic> toMap();
}

class MemoTable extends DatabaseTable {
  MemoTable({
    @required id,
    this.title = "",
    this.content = "",
    this.date,
  }) : super(name, id: id);

  final String title;
  final String content;
  final DateTime date;

  static final String name = 'memo_table';

  factory MemoTable.fromMap(Map<String, dynamic> map) => MemoTable(
        id: map["id"],
        title: map["title"],
        content: map["content"],
        date: DateTime.parse(map["date"]).toLocal(),
      );

  @override
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "content": content,
        "date": date.toUtc().toIso8601String(),
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

class TagTable extends DatabaseTable {
  TagTable({
    @required id,
    this.tagName = "",
  }) : super(name, id: id);

  final String tagName;

  static final String name = 'tag_table';

  factory TagTable.fromMap(Map<String, dynamic> map) => TagTable(
        id: map["id"],
        tagName: map["tag_name"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "id": id,
        "tag_name": tagName,
      }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

class TagMemoTable extends DatabaseTable {
  TagMemoTable({
    @required this.memoId,
    @required this.tagId,
  }) : super(name, id: memoId);

  final int memoId;
  final int tagId;

  static final String name = 'tag_memo_table';

  factory TagMemoTable.fromMap(Map<String, dynamic> map) => TagMemoTable(
    memoId: map["memo_id"],
    tagId: map["tag_id"],
  );

  @override
  Map<String, dynamic> toMap() => {
    "memo_id": memoId,
    "tag_id": tagId,
  }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}

class TrashTable extends DatabaseTable {
  TrashTable({
    @required id,
    this.title = "",
    this.content = "",
    this.date,
  }) : super(name, id: id);

  final String title;
  final String content;
  final DateTime date;

  static final String name = 'trash_table';

  factory TrashTable.fromMap(Map<String, dynamic> map) => TrashTable(
    id: map["id"],
    title: map["title"],
    content: map["content"],
    date: DateTime.parse(map["date"]).toLocal(),
  );

  @override
  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "content": content,
    "date": date.toUtc().toIso8601String(),
  }..removeWhere(
          (dynamic key, dynamic value) => key == null || value == null);
}
