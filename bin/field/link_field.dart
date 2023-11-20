import 'package:flutter_storyblok/link_type.dart';
import 'package:flutter_storyblok/utils.dart';

import 'base_field.dart';

final class LinkField extends BaseField {
  final bool isAssetAllowed;
  final bool isEmailAllowed;
  // final bool restrictContentType;
  // final List<String> restrictedTypes;
  LinkField.fromJson(super.data, super.name)
      : isAssetAllowed = data["asset_link_type"] ?? false,
        isEmailAllowed = data["email_link_type"] ?? false,
        // restrictContentType = data["restrict_content_types"] ?? false,
        // restrictedTypes = List.from(data["component_whitelist"] ?? []),
        super.fromJson();

  @override
  String symbol() {
    if (isAssetAllowed && isEmailAllowed) return "$LinkType";
    if (isAssetAllowed) return "$BaseWithAssetLinkTypes";
    if (isEmailAllowed) return "$BaseWithEmailLinkTypes";
    return "$BaseLinkTypes";
  }

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}.fromJson($JSONMap.from($valueCode))";
  }
}
