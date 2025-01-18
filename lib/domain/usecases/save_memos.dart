import '../entities/memo_entity.dart';
import '../repositories/memo_repository.dart';

class SaveMemos {
  final MemoRepository repository;

  SaveMemos(this.repository);

  Future<void> call(List<MemoEntity> memos) async {
    return repository.saveMemos(memos);
  }
}
