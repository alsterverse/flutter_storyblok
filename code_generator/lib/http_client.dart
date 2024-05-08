import 'dart:convert';

import 'package:flutter_storyblok/utils.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_storyblok_code_generator/utils/data_models.dart';

typedef DatasourceWithEntries = ({Datasource datasource, List<DatasourceEntry> entries});

class StoryblokHttpClient {
  final String spaceId;
  final String authorization;
  StoryblokHttpClient(this.spaceId, this.authorization);

  Future<List<Component>> getComponents() async {
    const key = "components";
    final data = await _get(key);
    return List<JSONMap>.from(data[key]).map(Component.fromJson).toList();
  }

  Future<List<DatasourceWithEntries>> getDatasourcesWithEntries() async {
    const key = "datasources";
    final data = await _get(key);
    final datasources = List<JSONMap>.from(data[key]).map(Datasource.fromJson).toList();

    final entries = await Future.wait(datasources.map(_getDatasourceEntry));
    // TODO: Dimensions
    return datasources.mapIndexed((i, ds) => (datasource: ds, entries: entries[i])).toList();
  }

  Future<List<DatasourceEntry>> _getDatasourceEntry(Datasource datasource) async {
    const key = "datasource_entries";
    final data = await _get(key, {"datasource_id": datasource.id.toString()});
    return List<JSONMap>.from(data[key]).map(DatasourceEntry.fromJson).toList();
  }

  static Future<List<JSONMap>> getDatasourceFromExternalSource(Uri url) async {
    final response = await http.get(url);
    final data = List<JSONMap>.from(jsonDecode(response.body));
    return data;
  }

  Future<JSONMap> _get(String path, [JSONMap? params]) async {
    final response = await http.get(
      Uri.https("mapi.storyblok.com", "/v1/spaces/$spaceId/$path", params),
      headers: {"Authorization": authorization},
    );
    final json = jsonDecode(response.body) as JSONMap;
    return json;
  }
}
