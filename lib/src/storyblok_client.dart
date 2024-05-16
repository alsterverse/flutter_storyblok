library flutter_storyblok;

import 'dart:convert';
import 'package:flutter_storyblok/src/datasource.dart';
import 'package:flutter_storyblok/src/request_parameters.dart';
import 'package:flutter_storyblok/src/story.dart';
import 'package:flutter_storyblok/src/tag.dart';
import 'package:flutter_storyblok/src/utils.dart';
import 'package:http/http.dart' as http;

final Map<String, Story> resolvedStories = {};

final class StoryblokClient<StoryContent> {
  static const _apiHost = "api.storyblok.com";

  static const _pathStories = "v2/cdn/stories";
  static const _pathTags = "v2/cdn/tags";
  static const _pathDatasources = "v2/cdn/datasources";
  static const _pathDatasourceEntries = "v2/cdn/datasource_entries";

  StoryblokClient({
    required this.accessToken,
    required this.version,
    required this.contentBuilder,
  }) : baseParameters = {
          "token": accessToken,
          "version": version.name,
        };
  final String accessToken;
  final StoryblokVersion version;
  final Map<String, String> baseParameters;
  final StoryContent Function(JSONMap) contentBuilder;

  Future<Story<StoryContent>> getStory({
    required StoryIdentifier id,
    StoryblokVersion version = StoryblokVersion.draft,
    ResolveLinks resolveLinks = ResolveLinks.story,
  }) async {
    final Map<String, String> queryParams = {
      "version": version.name,
      "resolve_links": resolveLinks.name,
    };
    final json = await switch (id) {
      StoryIdentifierID(id: final id) => _getRequest(
          path: "$_pathStories/$id",
          queryParameters: queryParams,
        ),
      StoryIdentifierUUID(uuid: final uuid) => _getRequest(
          path: "$_pathStories/$uuid",
          queryParameters: {
            ...queryParams,
            "find_by": "uuid",
          },
        ),
      StoryIdentifierFullSlug(slug: final slug) => _getRequest(
          path: "$_pathStories/$slug",
          queryParameters: queryParams,
        ),
    };
    if (resolveLinks == ResolveLinks.story) {
      List<JSONMap>.from(json["links"])
          .map((e) => Story.fromJson(e, contentBuilder))
          .forEach((story) => resolvedStories[story.uuid] = story);
    }
    final story = Story.fromJson(json["story"], contentBuilder);
    return story;
  }

  Future<List<Story<StoryContent>>> getStories({
    String? startsWith,
    String? searchTerm,
    Pagination? pagination,
    StoryblokVersion version = StoryblokVersion.draft,
    ResolveLinks resolveLinks = ResolveLinks.story,
  }) async {
    final json = await _getRequest(
      path: _pathStories,
      queryParameters: {
        if (startsWith != null) "starts_with": startsWith,
        if (searchTerm != null) "search_term": searchTerm,
        if (pagination != null) ...pagination.toParameters(),
        "version": version.name,
        "resolve_links": resolveLinks.name,
      },
    );
    if (resolveLinks == ResolveLinks.story) {
      List<JSONMap>.from(json["links"])
          .map(
            (e) => Story.fromJson(e, contentBuilder),
          )
          .forEach(
            (story) => resolvedStories[story.uuid] = story,
          );
    }
    return List<JSONMap>.from(json["stories"])
        .map(
          (e) => Story.fromJson(e, contentBuilder),
        )
        .toList();
  }

  Future<List<Datasource>> getDatasources({Pagination? pagination}) async {
    final json = await _getRequest(
      path: _pathDatasources,
      queryParameters: {
        if (pagination != null) ...pagination.toParameters(),
      },
    );
    return List<JSONMap>.from(json["datasources"]).map(Datasource.fromJson).toList();
  }

  Future<List<DatasourceEntry>> getDatasourceEntries({
    String? datasource,
    String? dimension,
    Pagination? pagination,
  }) async {
    final json = await _getRequest(
      path: _pathDatasourceEntries,
      queryParameters: {
        if (datasource != null) "datasource": datasource,
        if (dimension != null) "dimension": dimension,
        if (pagination != null) ...pagination.toParameters(),
      },
    );
    return List<JSONMap>.from(json["datasources"]).map(DatasourceEntry.fromJson).toList();
  }

  Future<List<Tag>> getTags({String? startsWith}) async {
    final json = await _getRequest(
      path: _pathTags,
      queryParameters: {
        if (startsWith != null) "starts_with": startsWith,
      },
    );
    return List<JSONMap>.from(json["tags"]).map(Tag.fromJson).toList();
  }

  Future<JSONMap> _getRequest({
    required String path,
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.https(
      _apiHost,
      path,
      {
        ...baseParameters,
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
      return json;
    } else {
      throw "Error code ${response.statusCode}, ${response.body}";
    }
  }
}
