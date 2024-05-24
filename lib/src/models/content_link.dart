import 'package:flutter_storyblok/src/utils.dart';

/// The Link Object contains a limited subset of the information
/// associated with a story (a content entry) or a folder.
final class ContentLink {
  /// The numeric ID
  final int id;

  /// Generated UUID string
  final String uuid;

  /// The full slug of the story or folder
  final String slug;

  /// Value of the real path defined in the story's entry configuration
  final String? path;

  /// Either the full slug of the story or folder with a leading /,
  /// or, if existent, the value of the real path defined in the story's
  /// entry configuration with a leading /
  final String realPath;

  /// The complete name of the story or folder
  final String name;

  /// true if a story has been published at least once (even if it is currently in draft)
  final bool published;

  /// ID of the parent folder
  final int? parentID;

  /// true if the instance constitutes a folder
  final bool isFolder;

  /// true if the story is defined as root for the folder
  final bool isStartpage;

  /// Numeric representation of the story's position in the folder
  final int position;

  // TODO: published/updated/created/_at
  // TODO: alternates

  const ContentLink({
    required this.id,
    required this.uuid,
    required this.slug,
    required this.path,
    required this.realPath,
    required this.name,
    required this.parentID,
    required this.published,
    required this.isFolder,
    required this.isStartpage,
    required this.position,
  });

  factory ContentLink.fromJson(JSONMap json) => ContentLink(
        id: json["id"],
        uuid: json["uuid"],
        slug: json["slug"],
        path: json["path"],
        realPath: json["real_path"],
        name: json["name"],
        parentID: json["parent_id"],
        published: json["published"],
        isFolder: json["is_folder"],
        isStartpage: json["is_startpage"],
        position: json["position"],
      );
}
