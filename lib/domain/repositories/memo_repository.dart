import '../entities/memo_entity.dart';

abstract class MemoRepository {
  Future<List<MemoEntity>> getMemos();
  Future<void> saveMemos(List<MemoEntity> memos);
}
