import 'package:flutter_storyblok/src/utils.dart';

final class ContentLink {
  final int id;
  final String uuid;
  final String slug;
  final String? path;
  final int? parentID;
  final String name;
  final bool isFolder;
  final bool published;
  final bool isStartpage;
  final int position;
  final String realPath;

  const ContentLink({
    required this.id,
    required this.uuid,
    required this.slug,
    required this.path,
    required this.parentID,
    required this.name,
    required this.isFolder,
    required this.published,
    required this.isStartpage,
    required this.position,
    required this.realPath,
  });

  factory ContentLink.fromJson(JSONMap json) => ContentLink(
        id: json["id"],
        uuid: json["uuid"],
        slug: json["slug"],
        path: json["path"],
        parentID: json["parent_id"],
        name: json["name"],
        isFolder: json["is_folder"],
        published: json["published"],
        isStartpage: json["is_startpage"],
        position: json["position"],
        realPath: json["real_path"],
      );
}
