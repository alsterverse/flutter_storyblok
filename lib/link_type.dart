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

final class LinkTypeURL extends LinkType {
  final Uri url;
  final String? target;
  const LinkTypeURL(this.url, this.target);
  factory LinkTypeURL.fromJson(JSONMap json) => LinkTypeURL(
        Uri.parse(json["url"]),
        json["target"],
      );
}

final class LinkTypeAsset extends LinkType {
  final Uri url;
  const LinkTypeAsset(this.url);
  factory LinkTypeAsset.fromJson(JSONMap json) => LinkTypeAsset(
        Uri.parse(json["url"]),
      );
}

final class LinkTypeEmail extends LinkType {
  final String email;
  const LinkTypeEmail(this.email);
  factory LinkTypeEmail.fromJson(JSONMap json) => LinkTypeEmail(
        json["email"],
      );
}

final class LinkTypeStory extends LinkType {
  final String uuid;
  final String? cachedUrl;
  const LinkTypeStory(this.uuid, this.cachedUrl);
  factory LinkTypeStory.fromJson(JSONMap json) => LinkTypeStory(
        json["id"],
        json["cached_url"],
      );
}
