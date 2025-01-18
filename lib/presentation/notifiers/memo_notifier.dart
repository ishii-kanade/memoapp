import 'package:flutter/foundation.dart';
import '../../domain/entities/memo_entity.dart';
import '../../domain/usecases/get_memos.dart';
import '../../domain/usecases/save_memos.dart';

class MemoNotifier extends ChangeNotifier {
  final GetMemos getMemosUseCase;
  final SaveMemos saveMemosUseCase;

  MemoNotifier({
    required this.getMemosUseCase,
    required this.saveMemosUseCase,
  });

  // Domain層の抽象である MemoEntity を利用
  List<MemoEntity> memos = [];

  Future<void> loadMemos() async {
    // getMemosUseCase() が返すリストの型は実際は List<MemoModel> かもしれないので、
    // 新たに List<MemoEntity> 型として再生成する
    memos = List<MemoEntity>.from(await getMemosUseCase());
    notifyListeners();
  }

  Future<void> addMemo(String text) async {
    memos.add(MemoEntity(text: text));
    await saveMemosUseCase(memos);
    notifyListeners();
  }

  Future<void> updateMemo(int index, String newText) async {
    final old = memos[index];
    memos[index] = MemoEntity(
      text: newText,
      isPinned: old.isPinned,
    );
    await saveMemosUseCase(memos);
    notifyListeners();
  }

  Future<void> deleteMemo(int index) async {
    memos.removeAt(index);
    await saveMemosUseCase(memos);
    notifyListeners();
  }

  Future<void> togglePin(int index) async {
    final old = memos[index];
    memos[index] = MemoEntity(
      text: old.text,
      isPinned: !old.isPinned,
    );
    memos.sort((a, b) => (b.isPinned ? 1 : 0) - (a.isPinned ? 1 : 0));
    await saveMemosUseCase(memos);
    notifyListeners();
  }
}
