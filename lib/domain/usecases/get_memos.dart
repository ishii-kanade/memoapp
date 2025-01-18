import '../entities/memo_entity.dart';
import '../repositories/memo_repository.dart';

class GetMemos {
  final MemoRepository repository;

  GetMemos(this.repository);

  Future<List<MemoEntity>> call() async {
    return repository.getMemos();
  }
}
