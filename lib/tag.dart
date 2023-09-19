import 'package:flutter_storyblok/utils.dart';

final class Tag {
  final String name;
  final int taggingsCount;

  const Tag({required this.name, required this.taggingsCount});

  factory Tag.fromJson(JSONMap json) => Tag(
        name: json["name"],
        taggingsCount: json["taggings_count"],
      );
}
