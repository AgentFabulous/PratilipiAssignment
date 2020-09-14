import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  Story({
    this.title,
    this.content,
    this.viewing,
    this.allReads,
  });

  String title;
  String content;
  List<String> viewing = [];
  List<String> allReads = [];

  Map<String, dynamic> toJson() => _$StoryToJson(this);

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
