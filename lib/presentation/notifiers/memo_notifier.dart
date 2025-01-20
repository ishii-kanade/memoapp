import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/memo_entity.dart';
import '../../domain/usecases/get_memos.dart';
import '../../domain/usecases/save_memos.dart';

class MemoNotifier extends StateNotifier<List<MemoEntity>> {
  final GetMemos getMemosUseCase;
  final SaveMemos saveMemosUseCase;

  MemoNotifier({
    required this.getMemosUseCase,
    required this.saveMemosUseCase,
  }) : super([]);

  Future<void> loadMemos() async {
    final loadedMemos = await getMemosUseCase();
    state = List<MemoEntity>.from(loadedMemos)
      ..sort((a, b) => b.lastEdited.compareTo(a.lastEdited)); // 最新順
  }

  Future<void> addMemo(String text, {List<String> tags = const []}) async {
    final newMemo = MemoEntity(
      text: text,
      tags: tags,
      lastEdited: DateTime.now(),
    );
    state = [newMemo, ...state];
    await saveMemosUseCase(state);
  }

  Future<void> updateMemo(int index, {required String newText, required List<String> newTags}) async {
    final updatedMemo = state[index].copyWith(
      text: newText,
      tags: newTags,
      lastEdited: DateTime.now(),
    );
    state = [
      for (int i = 0; i < state.length; i++) i == index ? updatedMemo : state[i]
    ];
    await saveMemosUseCase(state);
  }

  Future<void> deleteMemo(int index) async {
    state = [
      for (int i = 0; i < state.length; i++) if (i != index) state[i]
    ];
    await saveMemosUseCase(state);
  }

  Future<void> togglePin(int index) async {
    final toggledMemo = state[index].copyWith(isPinned: !state[index].isPinned);
    state = [
      for (int i = 0; i < state.length; i++) i == index ? toggledMemo : state[i]
    ];
    await saveMemosUseCase(state);
  }
}


