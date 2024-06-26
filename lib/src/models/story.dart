import 'package:flutter_storyblok/src/utils.dart';

// TODO: Uncomment properties, was commented when building Link<StoryContent> to save time

/// Storyblok Story, generic type Content depends on StoryblokClient.StoryContent generic type.
final class Story<Content> {
  final String name; // "Home",
  // final DateTime createdAt; // "2023-09-11T11:30:29.377Z",
  // final DateTime? publishedAt; // null,
  // final int id; // 368394281,
  final String uuid; // "9c66e06d-caa8-49fa-bdcc-f51b66f1d982",
  final Content content; // {},
  // final String slug; // "home",
  // final String fullSlug; // "home",
  // final String? sortByDate; // null,
  // final int position; // 0,
  // final List tagList; // [],
  // final bool isStartpage; // false,
  // final int? parentId; // 0,
  // final dynamic metaData; // null,
  // final String groupId; // "f963e087-8781-4efd-8110-46ad8ab796de",
  // final dynamic firstPublishedAt; // null,
  // final dynamic releaseId; // null,
  // final String lang; // "default",
  // final dynamic path; // null,
  // final List alternates; // [],
  // final dynamic defaultFullSlug; // null,
  // final dynamic translatedSlugs; // null

  Story({
    required this.name,
    // required this.createdAt,
    // required this.publishedAt,
    // required this.id,
    required this.uuid,
    required this.content,
    // required this.slug,
    // required this.fullSlug,
    // required this.sortByDate,
    // required this.position,
    // required this.tagList,
    // required this.isStartpage,
    // required this.parentId,
    // required this.metaData,
    // required this.groupId,
    // required this.firstPublishedAt,
    // required this.releaseId,
    // required this.lang,
    // required this.path,
    // required this.alternates,
    // required this.defaultFullSlug,
    // required this.translatedSlugs,
  });

  factory Story.fromJson(JSONMap json, Content Function(JSONMap) contentBuilder) => Story(
        name: json["name"],
        // createdAt: DateTime.parse(json["created_at"]),
        // publishedAt: mapIfNotNull(json["published_at"] as String?, DateTime.parse),
        // id: json["id"],
        uuid: json["uuid"],
        content: contentBuilder(JSONMap.from(json["content"])),
        // slug: json["slug"],
        // fullSlug: json["full_slug"],
        // sortByDate: json["sort_by_date"],
        // position: json["position"],
        // tagList: List.from(json["tag_list"]),
        // isStartpage: json["is_startpage"],
        // parentId: json["parent_id"],
        // metaData: json["meta_data"],
        // groupId: json["group_id"],
        // firstPublishedAt: json["first_published_at"],
        // releaseId: json["release_id"],
        // lang: json["lang"],
        // path: json["path"],
        // alternates: List.from(json["alternates"]),
        // defaultFullSlug: json["default_full_slug"],
        // translatedSlugs: json["translated_slugs"],
      );

  factory Story.from(Story story) {
    return Story(
      name: story.name,
      uuid: story.uuid,
      content: story.content,
    );
  }
}
