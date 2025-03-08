import 'package:flutter/material.dart';

class UserBible {
  final int name;
  final int chapter;
  final int verse;
  final bool isPlayEnabled;

   const UserBible({
    required this.name,
    required this.chapter,
    required this.verse,
    required this.isPlayEnabled

  });


  static UserBible? fromJson(dynamic json) {
    return json != null
        ? new UserBible(
            name: json["name"] ?? 0,
            chapter: json["chapter"] ?? 0,
            verse: json["verse"] ?? 0,
            isPlayEnabled: json["isPlayEnabled"] ?? false
            )
        : null;
  }

  dynamic toJson() {
    return {
      "name": name,
      "fichapterrstName": chapter,
      "verse": verse,
      "isPlayEnabled": isPlayEnabled
    };
  }
}
