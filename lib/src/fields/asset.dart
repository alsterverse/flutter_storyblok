import 'package:flutter_storyblok/src/utils.dart';

/// Storyblok Asset field
sealed class Asset {
  /// Alt text for the asset
  final String alt;

  /// File name for the asset
  final String name;

  /// The focus point of the image (Only for image assets)
  final String focus;

  /// Title of the asset
  final String title;

  /// Copyright text for the asset
  final String copyright;

  /// Full path of the asset, including the file name
  final String fileName;

  /// Includes custom metadata fields for an asset along with the default ones.
  /// It also contains the translations of the same if added in the format metafield__i18n__langcode .
  /// This field should be used for updating the metadata including the default ones. (alt, title, source, copyright)
  final JSONMap? metadata;

  Asset.fromJson(JSONMap json)
      : alt = json["alt"] ?? "",
        name = json["name"] ?? "",
        focus = json["focus"] ?? "",
        title = json["title"] ?? "",
        copyright = json["copyright"] ?? "",
        fileName = json["filename"] ?? "",
        metadata = mapIfNotNull(json["metadata"] as Map?, (e) => JSONMap.from(e));
}

/// Asset was configured in Storyblok as only pointing to an image file
final class ImageAsset extends Asset {
  ImageAsset.fromJson(super.json)
      : imageUrl = Uri.parse(json["filename"]),
        super.fromJson();

  /// URL of an image file
  final Uri imageUrl;
}

/// Asset was configured in Storyblok as only pointing to a video file
final class VideoAsset extends Asset {
  VideoAsset.fromJson(super.json)
      : videoUrl = Uri.parse(json["filename"]),
        super.fromJson();

  /// URL of a video file
  final Uri videoUrl;
}

/// Asset was configured in Storyblok as only pointing to an audio file
final class AudioAsset extends Asset {
  AudioAsset.fromJson(super.json)
      : audioUrl = Uri.parse(json["filename"]),
        super.fromJson();

  /// URL of an audio file
  final Uri audioUrl;
}

/// Asset was configured in Storyblok as only pointing to a text-based file
final class TextAsset extends Asset {
  TextAsset.fromJson(super.json)
      : fileUrl = Uri.parse(json["filename"]),
        super.fromJson();

  /// URL of a text file
  final Uri fileUrl;
}
