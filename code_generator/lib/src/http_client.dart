import 'dart:convert';

import 'package:flutter_storyblok_code_generator/src/models/component.dart';
import 'package:flutter_storyblok_code_generator/src/models/datasource.dart';
import 'package:flutter_storyblok_code_generator/src/models/datasource_entry.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import 'utils/utils.dart';

typedef DatasourceWithEntries = ({Datasource datasource, List<DatasourceEntry> entries});

class StoryblokHttpClient {
  final String spaceId;
  final String authorization;
  StoryblokHttpClient(this.spaceId, this.authorization);

  final _rateLimit = _RateLimit();

  Future<List<Component>> getComponents() async {
    const key = "components";
    final data = await _get(key);
    final jsons = tryCast<List>(data[key]);
    if (jsons == null) throwMessage("Failed to fetch $key make sure your PAT is correct");
    return List<JSONMap>.from(jsons).map(Component.fromJson).toList();
  }

  Future<List<DatasourceWithEntries>> getDatasourcesWithEntries() async {
    const key = "datasources";
    final data = await _get(key);
    final jsons = tryCast<List>(data[key]);
    if (jsons == null) throwMessage("Failed to fetch $key make sure your PAT is correct");
    final datasources = List<JSONMap>.from(jsons).map(Datasource.fromJson).toList();

    final entries = await Future.wait(datasources.map(_getDatasourceEntry));
    // TODO: Dimensions
    return datasources.mapIndexed((i, ds) => (datasource: ds, entries: entries[i])).toList();
  }

  Future<List<DatasourceEntry>> _getDatasourceEntry(Datasource datasource) async {
    const key = "datasource_entries";
    final data = await _get(key, {"datasource_id": datasource.id.toString()});
    return List<JSONMap>.from(data[key]).map(DatasourceEntry.fromJson).toList();
  }

  // TODO: Add way to configure fetching non-public resources
  Future<List<JSONMap>> getExternalDatasourceEntries(Uri url) async {
    final response = await http.get(url);
    final data = List<JSONMap>.from(jsonDecode(response.body));
    return data;
  }

  Future<JSONMap> _get(String path, [JSONMap? params]) async {
    await _rateLimit();

    final response = await http.get(
      Uri.https("mapi.storyblok.com", "/v1/spaces/$spaceId/$path", params),
      headers: {"Authorization": authorization},
    );
    final json = jsonDecode(response.body);
    if (json is JSONMap) {
      return json;
    } else if (json is List) {
      throwMessage("Failed to fetch $path make sure space_id is correct. Error body: $json");
    } else {
      throwMessage("Unknown error");
    }
  }
}

class _RateLimit {
  static const _throttleLimit = 3;

  DateTime? _currentThrottleSessionStart;
  int _currentThrottleCounter = 0;
  Future? _waitFuture;

  void _reset() {
    _currentThrottleSessionStart = DateTime.now();
    _currentThrottleCounter = 0;
    _waitFuture = null;
  }

  Future<void> call() async {
    if (_currentThrottleSessionStart == null) {
      _reset();
    } else {
      final timeIntoSession = DateTime.now().difference(_currentThrottleSessionStart!).inMilliseconds;
      if (_currentThrottleCounter >= _throttleLimit) {
        _waitFuture ??= Future.delayed(Duration(milliseconds: 1000 - timeIntoSession + 10)).then((_) => _reset());
        await _waitFuture;
      }
    }
    _currentThrottleCounter += 1;
  }
}
