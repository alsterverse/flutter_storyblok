import 'package:flutter_storyblok/src/utils.dart';

class Plugin {
  Plugin({required this.fieldType, required this.data});
  factory Plugin.fromJson(JSONMap json, String fieldType) => Plugin(fieldType: fieldType, data: json);

  final String fieldType;
  final JSONMap data;
}
