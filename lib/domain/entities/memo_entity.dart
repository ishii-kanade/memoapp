class MemoEntity {
  final String text;
  final bool isPinned;
  final List<String> tags;

  const MemoEntity({
    required this.text,
    this.isPinned = false,
    this.tags = const [],
  });
}


