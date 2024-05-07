import 'package:flutter_storyblok/utils.dart';

final class Asset {
  final String alt;
  final String name;
  final String focus;
  final String title;
  final String copyright;
  final String fileName;
  final JSONMap? metadata;
  Asset.fromJson(JSONMap json)
      : alt = json["alt"],
        name = json["name"],
        focus = json["focus"],
        title = json["title"],
        copyright = json["copyright"],
        fileName = json["filename"],
        metadata = mapIfNotNull(json["metadata"] as Map?, (e) => JSONMap.from(e));
}

/*
* Create different asset types to handle it in app
*
* You need to create blocks in block library in Storyblok that implements assets
* and only takes images/videos/documents
*
* Note: If Storyblok send content_type we don't need this
* */
final class ImageAsset extends Asset {
  ImageAsset.fromJson(super.json) : super.fromJson();
}

final class VideoAsset extends Asset {
  VideoAsset.fromJson(super.json) : super.fromJson();
}
