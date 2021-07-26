import 'package:presc/model/utils/database_helper.dart';
import 'package:presc/model/utils/database_table.dart';

class ManuscriptManager {
  final _dbHelper = DatabaseHelper.instance;

  void insert() async {
    DatabaseTable table = MemoTable(
      id: 0,
      title: "test",
      content: "content",
      date: DateTime.now(),
    );
    final id = await _dbHelper.insert(table);
    print('inserted row id: $id');
  }

  void query() async {
    final res = await _dbHelper.queryAllRows(MemoTable.name);
    List<MemoTable> list = res.map((row) => MemoTable.fromMap(row)).toList();
    print(list.first.toMap());
  }
}
