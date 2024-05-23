import 'package:flutter_storyblok_code_generator/src/utils/utils.dart';

class Datasource {
  final int id;
  final String slug;
  // final dynamic dimensions;
  Datasource.fromJson(JSONMap json)
      : id = json["id"],
        slug = json["slug"];
}
