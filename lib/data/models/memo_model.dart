import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/memo_entity.dart';

part 'memo_model.g.dart'; // 自動生成ファイルの名前

@JsonSerializable()
class MemoModel extends MemoEntity {
  const MemoModel({
    required super.text,
    super.isPinned,
    super.tags,
    required super.lastEdited,
  });

  // JSON からインスタンスを生成
  factory MemoModel.fromJson(Map<String, dynamic> json) => _$MemoModelFromJson(json);

  // インスタンスを JSON に変換
  Map<String, dynamic> toJson() => _$MemoModelToJson(this);
}
