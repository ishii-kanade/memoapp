import '../../domain/entities/memo_entity.dart';

class MemoModel extends MemoEntity {
  const MemoModel({
    required super.text,
    super.isPinned,
  });

  factory MemoModel.fromJson(Map<String, dynamic> json) {
    return MemoModel(
      text: json['text'] as String,
      isPinned: (json['isPinned'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isPinned': isPinned,
    };
  }
}
