import '../../domain/entities/memo_entity.dart';

class MemoModel extends MemoEntity {
  const MemoModel({
    required super.text,
    super.isPinned,
    super.tags,
  });

  factory MemoModel.fromJson(Map<String, dynamic> json) {
    return MemoModel(
      text: json['text'] as String,
      isPinned: json['isPinned'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((tag) => tag as String)
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isPinned': isPinned,
      'tags': tags,
    };
  }
}
