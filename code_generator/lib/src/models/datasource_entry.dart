import 'package:flutter_storyblok_code_generator/src/utils/utils.dart';

class DatasourceEntry {
  final int id;
  final String name;
  final String value;
  // final dynamic dimensions;
  DatasourceEntry.fromJson(JSONMap json)
      : id = json["id"],
        name = json["name"],
        value = json["value"];
}
