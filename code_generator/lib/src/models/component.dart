import 'package:flutter_storyblok_code_generator/src/utils/utils.dart';

class Component {
  final String name;
  final JSONMap schema;
  final bool isRoot;
  final bool isNestable;
  Component.fromJson(JSONMap json)
      : name = json["name"],
        isRoot = json["is_root"],
        isNestable = json["is_nestable"],
        schema = JSONMap.from(json["schema"]);
}
