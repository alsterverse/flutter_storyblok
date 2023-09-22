library flutter_storyblok;

import 'dart:convert';
import 'package:flutter_storyblok/datasource.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/story.dart';
import 'package:flutter_storyblok/tag.dart';
import 'package:flutter_storyblok/utils.dart';
import 'package:http/http.dart' as http;



final class StoryblokClient {
  static const _apiHost = "api.storyblok.com";

  static const _pathStories = "v2/cdn/stories";
  static const _pathTags = "v2/cdn/tags";
  static const _pathDatasources = "v2/cdn/datasources";
  static const _pathDatasourceEntries = "v2/cdn/datasource_entries";

  StoryblokClient({
    required this.accessToken,
    required this.version,
  }) : baseParameters = {
          "token": accessToken,
          "version": version.name,
        };
  final String accessToken;
  final StoryblokVersion version;
  final Map<String, String> baseParameters;

  Future<Story> getStory({
    required StoryIdentifier id,
    StoryblokVersion version = StoryblokVersion.published,
  }) async {
    final json = await switch (id) {
      StoryIdentifierID(id: final id) => _getRequest(
          path: "$_pathStories/$id",
        ),
      StoryIdentifierUUID(uuid: final uuid) => _getRequest(
          path: "$_pathStories/$uuid",
          queryParameters: {
            "find_by": "uuid",
          },
        ),
      StoryIdentifierFullSlug(slug: final slug) => _getRequest(
          path: "$_pathStories/$slug",
        ),
    };
    return Story.fromJson(json["story"]);
  }

  Future<List<Story>> getStories({String? startsWith, Pagination? pagination}) async {
    final json = await _getRequest(
      path: _pathStories,
      queryParameters: {
        if (startsWith != null) "starts_with": startsWith,
        if (pagination != null) ...pagination.toParameters(),
      },
    );
    return List<JSONMap>.from(json["stories"]).map(Story.fromJson).toList();
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

/*
final class Component {
  final String name; //: "page",
  final String? displayName; //: null,
  final DateTime createdAt; //: "2023-09-11T11:30:29.289Z",
  final DateTime updatedAt; //: "2023-09-11T11:33:44.295Z",
  final String id; //: 4553360,
  final Map<String, List<JSONMap>> schema; //: {},
  final String? image; //: null,
  final String? previewField; //: null,
  final bool isRoot; //: true,
  final String? previewTmpl; //: null,
  final bool isNestable; //: false,
  final List<JSONMap> allPresets; //: [],
  final String? presetId; //: null,
  final String realName; //: "page",
  final String? componentGroupUuid; //: null,
  final String? color; //: null,
  final String? icon; //: null

  Component({
    required this.name,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.schema,
    required this.image,
    required this.previewField,
    required this.isRoot,
    required this.previewTmpl,
    required this.isNestable,
    required this.allPresets,
    required this.presetId,
    required this.realName,
    required this.componentGroupUuid,
    required this.color,
    required this.icon,
  });

  factory Component.fromJson(JSONMap json) => Component(
        name: json["name"],
        displayName: json["display_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        id: json["id"],
        schema: Map.from(json["schema"]),
        image: json["image"],
        previewField: json["preview_field"],
        isRoot: json["is_root"],
        previewTmpl: json["preview_tmpl"],
        isNestable: json["is_nestable"],
        allPresets: List.from(json["all_presets"]),
        presetId: json["preset_id"],
        realName: json["real_name"],
        componentGroupUuid: json["component_group_uuid"],
        color: json["color"],
        icon: json["icon"],
      );
}


final class NestedComponent {
  final String id;
  final JSONMap data;

  NestedComponent({
    required this.id,
    required this.data,
  });

  factory NestedComponent.fromJson(JSONMap json) => NestedComponent(
        id: json["component"],
        data: json,
      );
}
*/

