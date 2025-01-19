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
    memos = List<MemoEntity>.from(await getMemosUseCase());
    notifyListeners();
  }

  Future<void> addMemo(String text, {List<String> tags = const []}) async {
    memos.add(MemoEntity(text: text, tags: tags));
    await saveMemosUseCase(memos);
    notifyListeners();
  }

  Future<void> updateMemo(int index, {required String newText, required List<String> newTags}) async {
    final old = memos[index];
    memos[index] = MemoEntity(
      text: newText,
      tags: newTags,
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
      tags: old.tags,
      isPinned: !old.isPinned,
    );
    memos.sort((a, b) => (b.isPinned ? 1 : 0) - (a.isPinned ? 1 : 0));
    await saveMemosUseCase(memos);
    notifyListeners();
  }
}
