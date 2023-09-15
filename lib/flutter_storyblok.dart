library flutter_storyblok;

import 'dart:convert';
import 'package:flutter_storyblok/story.dart';
import 'package:flutter_storyblok/utils.dart';
import 'package:http/http.dart' as http;

enum StoryblokVersion {
  draft,
  published,
}

final class StoryblokClient {
  static const _apiHost = "api.storyblok.com";

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

  Future<Story> getStory(StoryIdentifier id) async {
    const basePath = "v2/cdn/stories";
    final Uri url = switch (id) {
      StoryIdentifierID(id: final id) => Uri.https(_apiHost, "$basePath/$id", baseParameters),
      StoryIdentifierUUID(uuid: final uuid) =>
        Uri.https(_apiHost, "$basePath/$uuid", {...baseParameters, "find_by": "uuid"}),
    };

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as JSONMap;
      return Story.fromJson(json["story"]);
    } else {
      throw "Error code ${response.statusCode}, ${response.body}";
    }
  }

  Future<List<Story>> getStories(String startsWith) async {
    const basePath = "v2/cdn/stories";
    final url = Uri.https(_apiHost, basePath, {...baseParameters, "starts_with": startsWith});

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as JSONMap;
      return List<JSONMap>.from(json["stories"]).map(Story.fromJson).toList();
    } else {
      throw "Error code ${response.statusCode}, ${response.body}";
    }
  }
}

sealed class StoryIdentifier {}

final class StoryIdentifierID extends StoryIdentifier {
  final int id;
  StoryIdentifierID(this.id);
}

final class StoryIdentifierUUID extends StoryIdentifier {
  final String uuid;
  StoryIdentifierUUID(this.uuid);
}

// final class StoryIdentifierFullSlug {
//   final String slug;
//   StoryIdentifierFullSlug(this.slug);
// }

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

