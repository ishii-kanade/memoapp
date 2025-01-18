class MemoEntity {
  final String text;
  final bool isPinned;

  const MemoEntity({
    required this.text,
    this.isPinned = false,
  });
}
