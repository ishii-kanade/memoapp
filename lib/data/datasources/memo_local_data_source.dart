abstract class MemoLocalDataSource {
  Future<List<Map<String, dynamic>>> loadMemos();
  Future<void> saveMemos(List<Map<String, dynamic>> memos);
}
