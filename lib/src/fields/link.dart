/// A Link from Storyblok can always point to either an external URL or a Story.
/// Therefore `LinkTypes` is needed as a base class.
/// A Link field can specify additional link types, email and asset.
///
/// This creates a challenge with exhaustive checking
/// To resolve this challenge:
/// DefaultLink is used if neither email nor asset is specified.
/// DefaultWithEmailLink if only email is specified.
/// DefaultWithAssetLink if only asset is specified.
/// If both are specified Link is used.
library;

import 'package:flutter_storyblok/models.dart';
import 'package:flutter_storyblok/src/utils.dart';

/// StoryContent is used to pass the Content type to LinkStory
sealed class Link<StoryContent> {
  const Link();
  factory Link.fromJson(JSONMap json) {
    final type = json["linktype"];
    return switch (type) {
      "url" => LinkURL.fromJson(json),
      "asset" => LinkAsset.fromJson(json),
      "email" => LinkEmail.fromJson(json),
      "story" => LinkStory.fromJson(json),
      _ => throw "Unrecognized linktype: $type",
    };
  }
}

/// URL or Story link
sealed class DefaultLink<StoryContent> extends Link<StoryContent> {
  DefaultLink();
  factory DefaultLink.fromJson(JSONMap json) => Link<StoryContent>.fromJson(json) as DefaultLink<StoryContent>;
}

/// URL, Story or Asset link
sealed class DefaultWithAssetLink<StoryContent> extends Link<StoryContent> {
  DefaultWithAssetLink();
  factory DefaultWithAssetLink.fromJson(JSONMap json) =>
      Link<StoryContent>.fromJson(json) as DefaultWithAssetLink<StoryContent>;
}

/// URL, Story or Email link
sealed class DefaultWithEmailLink<StoryContent> extends Link<StoryContent> {
  DefaultWithEmailLink();
  factory DefaultWithEmailLink.fromJson(JSONMap json) =>
      Link<StoryContent>.fromJson(json) as DefaultWithEmailLink<StoryContent>;
}

// MARK: - Concrete classes

/// Link to a URL
final class LinkURL<StoryContent> extends DefaultLink<StoryContent> {
  LinkURL.fromJson(JSONMap json) : url = Uri.parse(json["url"] ?? json["href"]);

  /// The external url
  final Uri url;
}

/// Link to a story
/// Generic type StoryContent is used to resolve a type-safe story
final class LinkStory<StoryContent> extends DefaultLink<StoryContent> {
  LinkStory.fromJson(JSONMap json)
      : uuid = json["id"] ?? json["uuid"],
        fullSlug = json["cached_url"] ?? json["href"],
        anchor = json["anchor"],
        target = json["target"];

  /// UUID of the story
  final String uuid;

  /// Full slug to the story
  final String? fullSlug;

  /// Anchor ID
  final String? anchor;

  /// Target value
  final String? target;

  /// Intended to be used by passing StoryblokClient.getResolvedStory
  /// T is needed to couple the generic content type.
  Story<StoryContent>? getStory<T>(Story<T>? Function(String uuid) getResolvedStory) {
    final story = getResolvedStory(uuid);
    if (story == null) return null;
    return Story.from(story);
  }
}

/// Link to an asset
final class LinkAsset<StoryContent> extends DefaultWithAssetLink<StoryContent> {
  LinkAsset.fromJson(JSONMap json)
      : url = Uri.parse(json["url"] ?? json["href"]),
        target = json["target"];

  /// URL to the asset
  final Uri url;

  /// Target value
  final String? target;
}

/// Link to an email address
final class LinkEmail<StoryContent> extends DefaultWithEmailLink<StoryContent> {
  LinkEmail.fromJson(JSONMap json) : email = json["email"] ?? json["href"];

  /// Email address
  final String email;
}
