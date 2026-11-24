import 'dart:convert';

import 'package:flutter_storyblok/client.dart';
import 'package:flutter_storyblok/models.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

/// JSON of a minimal story.
const storyJson = <String, dynamic>{
  "name": "Home",
  "created_at": "2024-01-02T03:04:05.000Z",
  "id": 1,
  "uuid": "story-uuid",
  "content": <String, dynamic>{"component": "page"},
  "slug": "home",
  "full_slug": "home",
  "position": 0,
  "tag_list": <String>[],
  "is_startpage": false,
  "group_id": "group",
  "lang": "default",
  "alternates": <dynamic>[],
};

/// JSON satisfying every endpoint of the client.
const responseJson = <String, dynamic>{
  "story": storyJson,
  "stories": <dynamic>[],
  "datasources": <dynamic>[],
  "datasource_entries": <dynamic>[],
  "links": <dynamic>[],
  "tags": <dynamic>[],
};

/// Returns a client for tests, optionally requesting [version].
StoryblokClient<Map<String, dynamic>> buildClient({ContentVersion? version, bool useCacheInvalidation = true}) =>
    StoryblokClient(
      accessToken: "secret",
      version: version,
      useCacheInvalidation: useCacheInvalidation,
      storyContentBuilder: (json) => json,
    );

/// Runs [call] against a fake server answering with [json] and [status], and returns the requests it received.
Future<List<http.Request>> capture(
  Future<void> Function() call, {
  Map<String, dynamic> json = responseJson,
  int status = 200,
}) async {
  final requests = <http.Request>[];
  await http.runWithClient(
    call,
    () => MockClient((request) async {
      requests.add(request);
      return http.Response(jsonEncode(json), status);
    }),
  );
  return requests;
}

/// Runs [call] and expects exactly one GET to [path] with exactly [query] besides the access token.
Future<void> expectRequest(Future<void> Function() call, String path, Map<String, String> query) async {
  final request = (await capture(call)).single;
  expect(request.method, "GET");
  expect(request.url.path, "/v2/cdn/$path");
  expect(request.headers["Accept"], "application/json");
  expect(request.url.queryParameters, {"token": "secret", ...query});
}

void main() {
  group('Test getStory', () {
    test('Test omitted parameters are not sent', () async {
      await expectRequest(
        () => buildClient().getStory(id: const StoryIdentifierID(1)),
        "stories/1",
        {"resolve_links_level": "2"},
      );
    });

    test('Test all parameters', () async {
      await expectRequest(
        () => buildClient(version: ContentVersion.draft).getStory(
          id: const StoryIdentifierFullSlug("a/b"),
          resolveLinks: ResolveLinks.url,
          resolveLinks2Levels: false,
          resolveRelations: ["a.b", "c.d"],
          fromRelease: "release",
          language: "sv",
          fallbackLanguage: "en",
          resolveAssets: 1,
        ),
        "stories/a/b",
        {
          "version": "draft",
          "resolve_links": "url",
          "resolve_relations": "a.b,c.d",
          "from_release": "release",
          "language": "sv",
          "fallback_lang": "en",
          "resolve_assets": "1",
        },
      );
    });

    test('Test each optional string is sent alone', () async {
      const id = StoryIdentifierUUID("u");
      const base = {"find_by": "uuid", "resolve_links_level": "2"};
      final client = buildClient();
      await expectRequest(() => client.getStory(id: id, fromRelease: "r"), "stories/u", {...base, "from_release": "r"});
      await expectRequest(() => client.getStory(id: id, language: "sv"), "stories/u", {...base, "language": "sv"});
      await expectRequest(() => client.getStory(id: id, fallbackLanguage: "en"), "stories/u", {
        ...base,
        "fallback_lang": "en",
      });
    });

    test('Test empty strings are still sent', () async {
      await expectRequest(
        () => buildClient().getStory(id: const StoryIdentifierID(1), language: ""),
        "stories/1",
        {"resolve_links_level": "2", "language": ""},
      );
    });
  });

  group('Test getStories', () {
    test('Test omitted parameters are not sent', () async {
      await expectRequest(() => buildClient().getStories(), "stories", {"resolve_links_level": "2"});
    });

    test('Test all parameters', () async {
      await expectRequest(
        () => buildClient(version: ContentVersion.published).getStories(
          startsWith: "blog/",
          searchTerm: "å & b",
          sortBy: "name:asc",
          pagination: const Pagination(page: 2, perPage: 10),
          byFullSlugs: ["a", "b"],
          excludingFullSlugs: ["c"],
          publishedAfter: DateTime(2024, 1, 2, 3, 4),
          publishedBefore: DateTime(2024, 2, 3, 4, 5),
          firstPublishedAfter: DateTime(2024, 3, 4, 5, 6),
          firstPublishedBefore: DateTime(2024, 4, 5, 6, 7),
          inWorkflowStages: [1, 2],
          contentType: "page",
          level: 3,
          resolveRelations: ["a.b"],
          excludingIDs: ["4", "5"],
          byUUIDs: (uuids: ["x", "y"], ordered: true),
          withTags: ["t", "u"],
          isStartpage: false,
          resolveLinks: ResolveLinks.link,
          fromRelease: "release",
          fallbackLanguage: "en",
          language: "sv",
          excludingFields: ["body"],
          resolveAssets: 1,
        ),
        "stories",
        {
          "version": "published",
          "starts_with": "blog/",
          "search_term": "å & b",
          "sort_by": "name:asc",
          "page": "2",
          "per_page": "10",
          "by_slugs": "a,b",
          "excluding_slugs": "c",
          "published_at_gt": "2024-01-02 03:04",
          "published_at_lt": "2024-02-03 04:05",
          "first_published_at_gt": "2024-03-04 05:06",
          "first_published_at_lt": "2024-04-05 06:07",
          "in_workflow_stages": "1,2",
          "content_type": "page",
          "level": "3",
          "resolve_relations": "a.b",
          "excluding_ids": "4,5",
          "by_uuids_ordered": "x,y",
          "with_tag": "t,u",
          "is_startpage": "0",
          "resolve_links": "link",
          "resolve_links_level": "2",
          "from_release": "release",
          "fallback_lang": "en",
          "language": "sv",
          "excluding_fields": "body",
          "resolve_assets": "1",
        },
      );
    });
  });

  group('Test datasources, links and tags', () {
    test('Test getDatasources', () async {
      await expectRequest(() => buildClient().getDatasources(), "datasources", {});
    });

    test('Test getDatasourceEntries', () async {
      await expectRequest(() => buildClient().getDatasourceEntries(datasource: "d"), "datasource_entries", {
        "datasource": "d",
      });
      await expectRequest(
        () => buildClient().getDatasourceEntries(
          datasource: "d",
          dimension: "sv",
          pagination: const Pagination(page: 1, perPage: 5),
        ),
        "datasource_entries",
        {"datasource": "d", "dimension": "sv", "page": "1", "per_page": "5"},
      );
    });

    test('Test getLinks', () async {
      await expectRequest(() => buildClient().getLinks(), "links", {"paginated": "1"});
      await expectRequest(
        () => buildClient().getLinks(startsWith: "blog/", parentID: "7", includeDates: true),
        "links",
        {"starts_with": "blog/", "with_parent": "7", "include_dates": "1", "paginated": "1"},
      );
    });

    test('Test getTags', () async {
      await expectRequest(() => buildClient().getTags(), "tags", {});
      await expectRequest(() => buildClient().getTags(startsWith: "blog/"), "tags", {"starts_with": "blog/"});
    });
  });

  group('Test responses', () {
    test('Test story is parsed', () async {
      late Story<Map<String, dynamic>> story;
      await capture(() async => story = await buildClient().getStory(id: const StoryIdentifierID(1)));
      expect(story.uuid, "story-uuid");
      expect(story.content, {"component": "page"});
    });

    test('Test cache version is sent on the next request', () async {
      final client = buildClient();
      final requests = await capture(() async {
        await client.getStories();
        await client.getStories();
        client.resetCacheVersion();
        await client.getStories();
      }, json: {...responseJson, "cv": 42});
      expect(requests.map((e) => e.url.queryParameters["cv"]), [null, "42", null]);
    });

    test('Test cache version is not sent without cache invalidation', () async {
      final client = buildClient(useCacheInvalidation: false);
      final requests = await capture(() async {
        await client.getStories();
        await client.getStories();
      }, json: {...responseJson, "cv": 42});
      expect(requests.map((e) => e.url.queryParameters["cv"]), [null, null]);
    });

    test('Test throws on error status', () async {
      await expectLater(
        capture(() => buildClient().getTags(), status: 404),
        throwsA(startsWith("Error code 404")),
      );
    });
  });
}
