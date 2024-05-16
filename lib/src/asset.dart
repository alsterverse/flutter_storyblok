import 'package:flutter_storyblok/src/utils.dart';

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

final class ImageAsset extends Asset {
  ImageAsset.fromJson(super.json)
      : imageUrl = Uri.parse(json["filename"]),
        super.fromJson();

  final Uri imageUrl;
}

final class VideoAsset extends Asset {
  VideoAsset.fromJson(super.json)
      : videoUrl = Uri.parse(json["filename"]),
        super.fromJson();

  final Uri videoUrl;
}

final class AudioAsset extends Asset {
  AudioAsset.fromJson(super.json)
      : audioUrl = Uri.parse(json["filename"]),
        super.fromJson();

  final Uri audioUrl;
}

final class TextAsset extends Asset {
  TextAsset.fromJson(super.json)
      : fileUrl = Uri.parse(json["filename"]),
        super.fromJson();

  final Uri fileUrl;
}
