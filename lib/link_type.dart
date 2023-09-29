import 'package:flutter_storyblok/flutter_storyblok.dart';
import 'package:flutter_storyblok/story.dart';
import 'package:flutter_storyblok/utils.dart';

sealed class LinkType {
  const LinkType();
  factory LinkType.fromJson(JSONMap json) => switch (json["linktype"]) {
        "url" => LinkTypeURL.fromJson(json),
        "asset" => LinkTypeAsset.fromJson(json),
        "email" => LinkTypeEmail.fromJson(json),
        "story" => LinkTypeStory.fromJson(json),
        _ => throw "Unrecognized linktype: ${json["linktype"]}",
      };
}

sealed class BaseLinkTypes extends LinkType {
  factory BaseLinkTypes.fromJson(JSONMap json) => LinkType.fromJson(json) as BaseLinkTypes;
}

sealed class BaseWithEmailLinkTypes extends LinkType {
  factory BaseWithEmailLinkTypes.fromJson(JSONMap json) => LinkType.fromJson(json) as BaseWithEmailLinkTypes;
}

sealed class BaseWithAssetLinkTypes extends LinkType {
  factory BaseWithAssetLinkTypes.fromJson(JSONMap json) => LinkType.fromJson(json) as BaseWithAssetLinkTypes;
}

final class LinkTypeURL extends LinkType implements BaseLinkTypes {
  final Uri url;
  final String? target;
  const LinkTypeURL(this.url, this.target);
  factory LinkTypeURL.fromJson(JSONMap json) => LinkTypeURL(
        Uri.parse(json["url"]),
        json["target"],
      );
}

final class LinkTypeAsset extends LinkType implements BaseWithAssetLinkTypes {
  final Uri url;
  const LinkTypeAsset(this.url);
  factory LinkTypeAsset.fromJson(JSONMap json) => LinkTypeAsset(
        Uri.parse(json["url"]),
      );
}

final class LinkTypeEmail extends LinkType implements BaseWithEmailLinkTypes {
  final String email;
  const LinkTypeEmail(this.email);
  factory LinkTypeEmail.fromJson(JSONMap json) => LinkTypeEmail(
        json["email"],
      );
}

final class LinkTypeStory extends LinkType implements BaseLinkTypes {
  final String uuid;
  final String? cachedUrl;
  final Story? resolvedStory;
  const LinkTypeStory(this.uuid, this.cachedUrl, this.resolvedStory);
  factory LinkTypeStory.fromJson(JSONMap json) {
    String uuid = json["id"];
    return LinkTypeStory(
      uuid,
      json["cached_url"],
      resolvedStories[uuid],
    );
  }
}
