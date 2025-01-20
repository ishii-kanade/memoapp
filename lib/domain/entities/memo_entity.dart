class MemoEntity {
  final String text;
  final bool isPinned;
  final List<String> tags;
  final DateTime lastEdited; // 最終編集日付を追加

  const MemoEntity({
    required this.text,
    this.isPinned = false,
    this.tags = const [],
    required this.lastEdited,
  });
}

extension CopyWith on MemoEntity {
  MemoEntity copyWith({
    String? text,
    List<String>? tags,
    bool? isPinned,
    DateTime? lastEdited,
  }) {
    return MemoEntity(
      text: text ?? this.text,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      lastEdited: lastEdited ?? this.lastEdited,
    );
  }
}


