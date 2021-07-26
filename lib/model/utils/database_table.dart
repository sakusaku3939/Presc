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
      };
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
      };
}

// class TrashTable extends _Table {
//   TrashTable({
//     @required id,
//     @required this.tagId,
//     this.title = "",
//     this.content = "",
//     this.date,
//   }) : super(name, id: id);
//
//   final List<String> tagId;
//   final String title;
//   final String content;
//   final DateTime date;
//
//   static final String name = 'trash_table';
//
//   @override
//   Map<String, dynamic> toMap() => {
//     "id": id,
//     "title": title,
//     "content": content,
//     "date": date.toUtc().toIso8601String(),
//   };
// }
