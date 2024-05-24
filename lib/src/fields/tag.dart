import 'package:flutter_storyblok/src/utils.dart';

/// Storyblok tag
final class Tag {
  const Tag({required this.name, required this.taggingsCount});

  factory Tag.fromJson(JSONMap json) => Tag(
        name: json["name"],
        taggingsCount: json["taggings_count"],
      );

  /// The complete name provided for the tag
  final String name;

  /// How many times this tag has been assigned to a story
  final int taggingsCount;
}
