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

  // メモをロード
  Future<void> loadMemos() async {
    final loadedMemos = await getMemosUseCase();
    state = List<MemoEntity>.from(loadedMemos);
  }

  // メモを追加
  Future<void> addMemo(String text, {List<String> tags = const []}) async {
    final newMemo = MemoEntity(text: text, tags: tags);
    state = [...state, newMemo];
    await saveMemosUseCase(state);
  }

  // メモを更新
  Future<void> updateMemo(int index, {required String newText, required List<String> newTags}) async {
    final updatedMemo = state[index].copyWith(text: newText, tags: newTags);
    state = [
      for (int i = 0; i < state.length; i++) i == index ? updatedMemo : state[i]
    ];
    await saveMemosUseCase(state);
  }

  // メモを削除
  Future<void> deleteMemo(int index) async {
    state = [
      for (int i = 0; i < state.length; i++) if (i != index) state[i]
    ];
    await saveMemosUseCase(state);
  }

  // ピンをトグル
  Future<void> togglePin(int index) async {
    final toggledMemo = state[index].copyWith(isPinned: !state[index].isPinned);
    state = [
      for (int i = 0; i < state.length; i++) i == index ? toggledMemo : state[i]
    ]..sort((a, b) => (b.isPinned ? 1 : 0) - (a.isPinned ? 1 : 0));
    await saveMemosUseCase(state);
  }
}

extension CopyWith on MemoEntity {
  MemoEntity copyWith({
    String? text,
    List<String>? tags,
    bool? isPinned,
  }) {
    return MemoEntity(
      text: text ?? this.text,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
