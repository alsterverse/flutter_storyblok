import 'dart:convert';
import 'package:flutter_storyblok/flutter_storyblok.dart';
import 'package:flutter_storyblok/src/fields/tag.dart';
import 'package:flutter_storyblok/src/utils.dart';
import 'package:http/http.dart' as http;

/// Used to fetch content from the Storyblok Content Delivery API
final class StoryblokClient<StoryContent> {
  static const _apiHost = "api.storyblok.com";

  static const _pathStories = "v2/cdn/stories";
  static const _pathDatasources = "v2/cdn/datasources";
  static const _pathDatasourceEntries = "v2/cdn/datasource_entries";
  static const _pathLinks = "v2/cdn/links";
  static const _pathTags = "v2/cdn/tags";

  StoryblokClient({
    required String accessToken,
    ContentVersion? version,
    bool useCacheInvalidation = true,
    required StoryContent Function(JSONMap) storyContentBuilder,
  })  : _baseParameters = {
          "token": accessToken,
        },
        _version = version,
        _useCacheInvalidation = useCacheInvalidation,
        _storyContentBuilder = storyContentBuilder;

  final ContentVersion? _version;
  final Map<String, String> _baseParameters;
  final bool _useCacheInvalidation;
  final StoryContent Function(JSONMap) _storyContentBuilder;

  /// Key is story UUID
  final Map<String, Story<StoryContent>> _resolvedStories = {};

  int? _cacheVersion;

  void resetCacheVersion() {
    _cacheVersion = null;
  }

  //
  // MARK: - Story

  /// Retrieve a single story by id
  Future<Story<StoryContent>> getStory({
    required StoryIdentifier id,
    // StoryblokVersion? version,
    ResolveLinks? resolveLinks,
    bool resolveLinks2Levels = true,
    List<String>? resolveRelations,
    String? fromRelease,
    // int? cacheVersion,
    String? language,
    String? fallbackLanguage,
    int? resolveAssets,
  }) async {
    final Map<String, String> queryParams = {
      if (_version != null) "version": _version.name,
      if (resolveLinks != null) "resolve_links": resolveLinks.name,
      if (resolveLinks2Levels) "resolve_links_level": "2",
      if (resolveRelations != null && resolveRelations.isNotEmpty) "resolve_relations": resolveRelations.join(","),
      if (fromRelease != null) "from_release": fromRelease,
      if (_cacheVersion != null) "cv": _cacheVersion.toString(),
      if (language != null) "language": language,
      if (fallbackLanguage != null) "fallback_lang": fallbackLanguage,
      if (resolveAssets != null)
        "resolve_assets": resolveAssets.toString(), // TODO: Figure out how resolve_assets works, docs doesnt say...
    };
    final json = await switch (id) {
      StoryIdentifierID(:final id) => _getRequest(
          path: "$_pathStories/$id",
          queryParameters: queryParams,
        ),
      StoryIdentifierUUID(:final uuid) => _getRequest(
          path: "$_pathStories/$uuid",
          queryParameters: {
            ...queryParams,
            "find_by": "uuid",
          },
        ),
      StoryIdentifierFullSlug(:final slug) => _getRequest(
          path: "$_pathStories/$slug",
          queryParameters: queryParams,
        ),
    };
    if (resolveLinks != null) {
      _handleResolvedLinks(resolveLinks, json);
    }
    if (resolveRelations != null && resolveRelations.isNotEmpty) {
      _handleResolvedRelations(json);
    }
    final story = Story<StoryContent>.fromJson(json["story"], _storyContentBuilder);
    return story;
  }

  /// Retrieve multiple stories
  Future<List<Story<StoryContent>>> getStories({
    // int? cacheVersion,
    // StoryblokVersion? version,
    String? startsWith,
    String? searchTerm,
    String? sortBy,
    Pagination? pagination,
    List<String>? byFullSlugs,
    List<String>? excludingFullSlugs,
    DateTime? publishedAfter,
    DateTime? publishedBefore,
    DateTime? firstPublishedAfter,
    DateTime? firstPublishedBefore,
    List<int>? inWorkflowStages,
    String? contentType,
    int? level,
    List<String>? resolveRelations,
    List<String>? excludingIDs,
    ({List<String> uuids, bool ordered})? byUUIDs,
    List<String>? withTags,
    bool? isStartpage,
    ResolveLinks? resolveLinks,
    bool resolveLinks2Levels = true,
    String? fromRelease,
    String? fallbackLanguage,
    String? language,
    // TODO: filter_query
    List<String>? excludingFields,
    int? resolveAssets,
  }) async {
    final json = await _getRequest(
      path: _pathStories,
      queryParameters: {
        if (_cacheVersion != null) "cv": _cacheVersion.toString(),
        if (_version != null) "version": _version.name,
        if (startsWith != null) "starts_with": startsWith,
        if (searchTerm != null) "search_term": searchTerm,
        if (sortBy != null) "sort_by": sortBy,
        if (pagination != null) ...pagination.toParameters(),
        if (byFullSlugs != null) "by_slugs": byFullSlugs.join(","),
        if (excludingFullSlugs != null) "excluding_slugs": excludingFullSlugs.join(","),
        if (publishedAfter != null) "published_at_gt": publishedAfter.format(),
        if (publishedBefore != null) "published_at_lt": publishedBefore.format(),
        if (firstPublishedAfter != null) "first_published_at_gt": firstPublishedAfter.format(),
        if (firstPublishedBefore != null) "first_published_at_lt": firstPublishedBefore.format(),
        if (inWorkflowStages != null) "in_workflow_stages": inWorkflowStages.join(","),
        if (contentType != null) "content_type": contentType,
        if (level != null) "level": level.toString(),
        if (resolveRelations != null && resolveRelations.isNotEmpty) "resolve_relations": resolveRelations.join(","),
        if (excludingIDs != null) "excluding_ids": excludingIDs.join(","),
        if (byUUIDs != null) byUUIDs.ordered ? "by_uuids_ordered" : "by_uuids": byUUIDs.uuids.join(","),
        if (withTags != null) "with_tag": withTags.join(","),
        if (isStartpage != null) "is_startpage": isStartpage ? "1" : "0",
        if (resolveLinks != null) "resolve_links": resolveLinks.name,
        if (resolveLinks2Levels) "resolve_links_level": "2",
        if (fromRelease != null) "from_release": fromRelease,
        if (fallbackLanguage != null) "fallback_lang": fallbackLanguage,
        if (language != null) "language": language,
        // TODO: filter_query
        if (excludingFields != null) "excluding_fields": excludingFields.join(","),
        if (resolveAssets != null) "resolve_assets": resolveAssets.toString(),
      },
    );
    if (resolveLinks != null) {
      _handleResolvedLinks(resolveLinks, json);
    }
    if (resolveRelations != null && resolveRelations.isNotEmpty) {
      _handleResolvedRelations(json);
    }
    final stories = List<JSONMap>.from(json["stories"]) //
        .map((e) => Story<StoryContent>.fromJson(e, _storyContentBuilder))
        .toList();
    return stories;
  }

  void _handleResolvedLinks(ResolveLinks resolveLinks, JSONMap json) {
    final links = List<JSONMap>.from(json["links"] ?? []);
    switch (resolveLinks) {
      case ResolveLinks.url:
        break; // TODO: _resolvedUrls
      case ResolveLinks.link:
        break; // TODO: _resolvedLinks
      case ResolveLinks.story:
        final stories = links.map((e) => Story.fromJson(e, _storyContentBuilder));
        for (final story in stories) {
          _resolvedStories[story.uuid] = story;
        }
    }
  }

  void _handleResolvedRelations(JSONMap json) {
    final rels = List<JSONMap>.from(json["rels"] ?? []);
    final stories = rels.map((e) => Story.fromJson(e, _storyContentBuilder));
    for (final story in stories) {
      _resolvedStories[story.uuid] = story;
    }
  }

  Story<StoryContent>? getResolvedStory(String uuid) {
    final story = _resolvedStories[uuid];
    return story;
  }

  //
  // MARK: - Datasources

  Future<List<Datasource>> getDatasources({
    Pagination? pagination,
  }) async {
    final json = await _getRequest(
      path: _pathDatasources,
      queryParameters: {
        if (pagination != null) ...pagination.toParameters(),
      },
    );
    return List<JSONMap>.from(json["datasources"]).map(Datasource.fromJson).toList();
  }

  Future<List<DatasourceEntry>> getDatasourceEntries({
    required String datasource,
    String? dimension,
    Pagination? pagination,
  }) async {
    final json = await _getRequest(
      path: _pathDatasourceEntries,
      queryParameters: {
        "datasource": datasource,
        if (dimension != null) "dimension": dimension,
        if (pagination != null) ...pagination.toParameters(),
      },
    );
    return List<JSONMap>.from(json["datasources"]).map(DatasourceEntry.fromJson).toList();
  }

  //
  // MARK: - Links

  Future<List<ContentLink>> getLinks({
    String? startsWith,
    // StoryblokVersion? version,
    // int? cacheVersion,
    String? parentID,
    bool? includeDates,
    Pagination? pagination,
  }) async {
    final json = await _getRequest(
      path: _pathLinks,
      queryParameters: {
        if (startsWith != null) "starts_with": startsWith,
        if (_version != null) "version": _version.name,
        if (_cacheVersion != null) "cv": _cacheVersion.toString(),
        if (parentID != null) "with_parent": parentID,
        if (includeDates != null) "include_dates": includeDates ? "1" : "0",
        if (pagination != null) ...pagination.toParameters(),
        "paginated": "1",
      },
    );
    return List<JSONMap>.from(json["links"]).map(ContentLink.fromJson).toList();
  }

  //
  // MARK: - Tags

  Future<List<Tag>> getTags({
    String? startsWith,
    // StoryblokVersion? version,
  }) async {
    final json = await _getRequest(
      path: _pathTags,
      queryParameters: {
        if (_version != null) "version": _version.name,
        if (startsWith != null) "starts_with": startsWith,
      },
    );
    return List<JSONMap>.from(json["tags"]).map(Tag.fromJson).toList();
  }

  //
  // MARK: - HTTP

  Future<JSONMap> _getRequest({
    required String path,
    Map<String, String>? queryParameters,
  }) async {
    final cacheVersion = _cacheVersion;
    // TODO: Rate limit https://www.storyblok.com/docs/api/content-delivery/v2/getting-started/rate-limit
    final uri = Uri.https(
      _apiHost,
      path,
      {
        ..._baseParameters,
        if (queryParameters != null) ...queryParameters,
      },
    );
    print(path);
    print(queryParameters);
    final response = await http.get(uri, headers: {
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as JSONMap;
      final cv = tryCast<int>(json["cv"]);

      // If use cache invalidation and if previous cacheVersion is older than the new one
      if (_useCacheInvalidation && (cacheVersion == null || (cv != null && cacheVersion < cv))) {
        _cacheVersion = cv;
      }

      return json;
    } else {
      throw "Error code ${response.statusCode}, ${response.body}";
    }
  }
}

extension _DateTimeFormat on DateTime {
  String format() {
    var year = this.year.toString().padLeft(4, "0");
    var month = this.month.toString().padLeft(2, "0");
    var day = this.day.toString().padLeft(2, "0");
    var hour = this.hour.toString().padLeft(2, "0");
    var minute = this.minute.toString().padLeft(2, "0");
    return "$year-$month-$day $hour:$minute";
  }
}
