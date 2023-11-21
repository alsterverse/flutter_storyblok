//MARK: - REST
import 'dart:convert';

import 'package:flutter_storyblok/utils.dart';
import 'package:http/http.dart' as http;

class StoryblokHttpClient {
  final String spaceId;
  final String authorization;
  StoryblokHttpClient(this.spaceId, this.authorization);

  Future<JSONMap> get(String path, [JSONMap? params]) async {
    final resp = await http.get(
      Uri.https("mapi.storyblok.com", "/v1/spaces/$spaceId/$path", params),
      headers: {"Authorization": authorization},
    );
    final json = jsonDecode(resp.body) as JSONMap;
    return json;
  }
}
