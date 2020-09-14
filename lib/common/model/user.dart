import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.username,
    this.salt,
    this.hash,
    this.token,
  });

  String username;
  String salt;
  String hash;
  String token;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
