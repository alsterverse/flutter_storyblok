import 'package:flutter_storyblok/utils.dart';

class Plugin {
  Plugin({required this.fieldType, required this.data});
  factory Plugin.fromJson(JSONMap json) => Plugin(fieldType: json["plugin"], data: json);

  final String fieldType;
  final JSONMap data;
}
