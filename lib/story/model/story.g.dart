// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) {
  return Story(
    title: json['title'] as String,
    content: json['content'] as String,
    viewing: (json['viewing'] as List)?.map((e) => e as String)?.toList(),
    allReads: (json['allReads'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'viewing': instance.viewing,
      'allReads': instance.allReads,
    };
