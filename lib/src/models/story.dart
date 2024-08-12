import 'package:flutter_storyblok/src/utils.dart';

/// Storyblok Story, generic type Content depends on StoryblokClient.StoryContent generic type.
class Story<Content> {
  final String name;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final int id;
  final String uuid;
  final Content content;
  final String slug;
  final String fullSlug;
  final String? sortByDate;
  final int position;
  final List tagList;
  final bool isStartpage;
  final int? parentId;
  final dynamic metaData;
  final String groupId;
  final DateTime? firstPublishedAt;
  final int? releaseId;
  final String language;
  final dynamic path;
  final List<dynamic> alternates;
  final dynamic defaultFullSlug;
  final dynamic translatedSlugs;

  Story({
    required this.name,
    required this.createdAt,
    this.publishedAt,
    required this.id,
    required this.uuid,
    required this.content,
    required this.slug,
    required this.fullSlug,
    this.sortByDate,
    required this.position,
    required this.tagList,
    required this.isStartpage,
    this.parentId,
    this.metaData,
    required this.groupId,
    this.firstPublishedAt,
    this.releaseId,
    required this.language,
    this.path,
    required this.alternates,
    this.defaultFullSlug,
    this.translatedSlugs,
  });

  factory Story.fromJson(JSONMap json, Content Function(JSONMap) contentBuilder) => Story(
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        publishedAt: mapIfNotNull(json["published_at"] as String?, DateTime.tryParse),
        id: json["id"],
        uuid: json["uuid"],
        content: contentBuilder(JSONMap.from(json["content"])),
        slug: json["slug"],
        fullSlug: json["full_slug"],
        sortByDate: json["sort_by_date"],
        position: json["position"],
        tagList: List.from(json["tag_list"]),
        isStartpage: json["is_startpage"],
        parentId: json["parent_id"],
        metaData: json["meta_data"],
        groupId: json["group_id"],
        firstPublishedAt: mapIfNotNull(json["first_published_at"] as String?, DateTime.tryParse),
        releaseId: json["release_id"],
        language: json["lang"],
        path: json["path"],
        alternates: List.from(json["alternates"]),
        defaultFullSlug: json["default_full_slug"],
        translatedSlugs: json["translated_slugs"],
      );

  factory Story.from(Story story) {
    return Story(
      name: story.name,
      createdAt: story.createdAt,
      publishedAt: story.publishedAt,
      id: story.id,
      uuid: story.uuid,
      content: story.content,
      slug: story.slug,
      fullSlug: story.fullSlug,
      sortByDate: story.sortByDate,
      position: story.position,
      tagList: story.tagList,
      isStartpage: story.isStartpage,
      parentId: story.parentId,
      metaData: story.metaData,
      groupId: story.groupId,
      firstPublishedAt: story.firstPublishedAt,
      releaseId: story.releaseId,
      language: story.language,
      path: story.path,
      alternates: story.alternates,
      defaultFullSlug: story.defaultFullSlug,
      translatedSlugs: story.translatedSlugs,
    );
  }
}
