import 'package:flutter_storyblok/src/storyblok_client.dart';
import 'package:flutter_storyblok/src/link_type.dart';
import 'package:flutter_storyblok/src/story.dart';
import 'package:flutter_storyblok/src/utils.dart';

sealed class Link {
  const Link();
  factory Link.fromJson(JSONMap json) {
    final type = json["linktype"];
    return switch (LinkType.fromName(type)) {
      LinkType.url => LinkTypeURL.fromJson(json),
      LinkType.asset => LinkTypeAsset.fromJson(json),
      LinkType.email => LinkTypeEmail.fromJson(json),
      LinkType.story => LinkTypeStory.fromJson(json),
      _ => throw "Unrecognized linktype: $type",
    };
  }
}

sealed class BaseLinkTypes extends Link {
  factory BaseLinkTypes.fromJson(JSONMap json) => Link.fromJson(json) as BaseLinkTypes;
}

sealed class BaseWithEmailLinkTypes extends Link {
  factory BaseWithEmailLinkTypes.fromJson(JSONMap json) => Link.fromJson(json) as BaseWithEmailLinkTypes;
}

sealed class BaseWithAssetLinkTypes extends Link {
  factory BaseWithAssetLinkTypes.fromJson(JSONMap json) => Link.fromJson(json) as BaseWithAssetLinkTypes;
}

final class LinkTypeURL extends Link implements BaseLinkTypes {
  final Uri url;
  final String? target;
  const LinkTypeURL(this.url, this.target);
  factory LinkTypeURL.fromJson(JSONMap json) => LinkTypeURL(
        Uri.parse(json["url"] ?? json["href"]),
        json["target"],
      );
}

final class LinkTypeAsset extends Link implements BaseWithAssetLinkTypes {
  final Uri url;
  const LinkTypeAsset(this.url);
  factory LinkTypeAsset.fromJson(JSONMap json) => LinkTypeAsset(
        Uri.parse(json["url"] ?? json["href"]),
      );
}

final class LinkTypeEmail extends Link implements BaseWithEmailLinkTypes {
  final String email;
  const LinkTypeEmail(this.email);
  factory LinkTypeEmail.fromJson(JSONMap json) => LinkTypeEmail(
        json["email"] ?? json["href"],
      );
}

final class LinkTypeStory extends Link implements BaseLinkTypes {
  final String uuid;
  final String? cachedUrl;
  final Story? resolvedStory;
  const LinkTypeStory(this.uuid, this.cachedUrl, this.resolvedStory);
  factory LinkTypeStory.fromJson(JSONMap json) {
    String uuid = json["id"] ?? json["uuid"];
    return LinkTypeStory(
      uuid,
      json["cached_url"] ?? json["href"],
      resolvedStories[uuid],
    );
  }
}
