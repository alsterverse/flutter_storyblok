import 'package:flutter_storyblok/utils.dart';

class Datasource {
  final int id;
  final String slug;
  // final dynamic dimensions;
  Datasource.fromJson(JSONMap json)
      : id = json["id"],
        slug = json["slug"];
}

class DatasourceEntry {
  final int id;
  final String name;
  final String value;
  // final dynamic dimensions;
  DatasourceEntry.fromJson(JSONMap json)
      : id = json["id"],
        name = json["name"],
        value = json["value"]
  //
  ;
}

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
