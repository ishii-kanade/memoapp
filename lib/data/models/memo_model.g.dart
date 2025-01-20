// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoModel _$MemoModelFromJson(Map<String, dynamic> json) => MemoModel(
      text: json['text'] as String,
      isPinned: json['isPinned'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      lastEdited: DateTime.parse(json['lastEdited'] as String),
    );

Map<String, dynamic> _$MemoModelToJson(MemoModel instance) => <String, dynamic>{
      'text': instance.text,
      'isPinned': instance.isPinned,
      'tags': instance.tags,
      'lastEdited': instance.lastEdited.toIso8601String(),
    };
