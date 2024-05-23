/// A Link from Storyblok can always point to either an external URL or a Story.
/// Therefore `LinkTypes` is needed as a base class.
/// A Link field can specify additional link types, email and asset.
///
/// This creates a challenge with exhaustive switches
/// To resolve this challenge:
/// DefaultLink is used if neither email nor asset is specified.
/// DefaultWithEmailLink if only email is specified.
/// DefaultWithAssetLink if only asset is specified.
/// If both are specified Link is used.
library;

import 'package:flutter_storyblok/flutter_storyblok.dart';
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

final class LinkURL<StoryContent> extends DefaultLink<StoryContent> {
  final Uri url;
  final String? target;
  LinkURL(this.url, this.target);
  factory LinkURL.fromJson(JSONMap json) => LinkURL(
        Uri.parse(json["url"] ?? json["href"]),
        json["target"],
      );
}

final class LinkStory<StoryContent> extends DefaultLink<StoryContent> {
  final String uuid;
  final String? cachedUrl;
  final String? anchor;
  final String? target;
  LinkStory({required this.uuid, this.cachedUrl, this.anchor, this.target});
  factory LinkStory.fromJson(JSONMap json) {
    String uuid = json["id"] ?? json["uuid"];
    return LinkStory(
      uuid: uuid,
      cachedUrl: json["cached_url"] ?? json["href"],
      anchor: json["anchor"],
      target: json["target"],
    );
  }

  /// Intended to be used by passing StoryblokClient.getResolvedStory
  /// T is needed to couple the generic content type.
  Story<StoryContent>? getStory<T>(Story<T>? Function(String uuid) getResolvedStory) {
    final story = getResolvedStory(uuid);
    if (story == null) return null;
    return Story.from(story);
  }
}

final class LinkAsset<StoryContent> extends DefaultWithAssetLink<StoryContent> {
  final Uri url;
  LinkAsset(this.url);
  factory LinkAsset.fromJson(JSONMap json) => LinkAsset(
        Uri.parse(json["url"] ?? json["href"]),
      );
}

final class LinkEmail<StoryContent> extends DefaultWithEmailLink<StoryContent> {
  final String email;
  LinkEmail(this.email);
  factory LinkEmail.fromJson(JSONMap json) => LinkEmail(
        json["email"] ?? json["href"],
      );
}
