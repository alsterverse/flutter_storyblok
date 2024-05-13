import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

import 'base_field.dart';
import '../utils/code_builder.dart';

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
  late final TypeReference type = referType(
    switch ((isAssetAllowed, isEmailAllowed)) {
      (true, true) => "$Link",
      (true, _) => "$BaseWithAssetLinkTypes",
      (_, true) => "$BaseWithEmailLinkTypes",
      _ => "$BaseLinkTypes",
    },
    importUrl: 'package:flutter_storyblok/flutter_storyblok.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) =>
      type.invokeNamed("fromJson", referJSONMap().invokeNamed("from", valueExpression));
}
