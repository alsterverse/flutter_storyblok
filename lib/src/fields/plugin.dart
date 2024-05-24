import 'package:flutter_storyblok/src/utils.dart';

/// Storyblok plugin
class Plugin {
  Plugin({required this.fieldType, required this.data});
  factory Plugin.fromJson(JSONMap json, String fieldType) => Plugin(fieldType: fieldType, data: json);

  /// Nname of the plugin
  final String fieldType;

  /// Plugin data
  final JSONMap data;
}
