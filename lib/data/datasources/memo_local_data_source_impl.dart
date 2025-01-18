import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'memo_local_data_source.dart';

class MemoLocalDataSourceImpl implements MemoLocalDataSource {
  Future<File> _getMemoFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/memos.json');
  }

  @override
  Future<List<Map<String, dynamic>>> loadMemos() async {
    try {
      final file = await _getMemoFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(content);
        return jsonList.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      // エラーログ等
    }
    return [];
  }

  @override
  Future<void> saveMemos(List<Map<String, dynamic>> memos) async {
    try {
      final file = await _getMemoFile();
      final content = jsonEncode(memos);
      await file.writeAsString(content);
    } catch (e) {
      // エラーログ等
      rethrow;
    }
  }
}
