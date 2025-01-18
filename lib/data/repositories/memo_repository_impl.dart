import '../../domain/entities/memo_entity.dart';
import '../../domain/repositories/memo_repository.dart';
import '../datasources/memo_local_data_source.dart';
import '../models/memo_model.dart';

class MemoRepositoryImpl implements MemoRepository {
  final MemoLocalDataSource localDataSource;

  MemoRepositoryImpl(this.localDataSource);

  @override
  Future<List<MemoEntity>> getMemos() async {
    final memosJson = await localDataSource.loadMemos();
    return memosJson.map((json) => MemoModel.fromJson(json)).toList();
  }

  @override
  Future<void> saveMemos(List<MemoEntity> memos) async {
    final memoModels = memos.map((entity) {
      return MemoModel(
        text: entity.text,
        isPinned: entity.isPinned,
      );
    }).toList();

    final memosJson = memoModels.map((m) => m.toJson()).toList();
    return localDataSource.saveMemos(memosJson);
  }
}
