// import 'package:flutter_storyblok/link_type.dart';
// import 'package:flutter_storyblok/reflector.dart';

import 'package:flutter_storyblok/utils.dart';

final class Asset {
  final String alt;
  final String name;
  final String focus;
  final String title;
  final String copyright;
  final String fileName;
  final JSONMap metadata;
  Asset.fromJson(JSONMap json)
      : alt = json["alt"],
        name = json["name"],
        focus = json["focus"],
        title = json["title"],
        copyright = json["copyright"],
        fileName = json["fileName"],
        metadata = json["metadata"];
}
