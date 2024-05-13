import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

final class AssetField extends BaseField {
  AssetField.fromJson(super.data, super.name)
      : assetTypes = List.from(data["filetypes"] ?? []),
        super.fromJson();
  final List<String> assetTypes;

  @override
  late final TypeReference type = referType(
    switch (assetTypes.length == 1 ? assetTypes.first : null) {
      "images" => "$ImageAsset",
      "videos" => "$VideoAsset",
      _ => "$Asset",
    },
    importUrl: 'package:flutter_storyblok/flutter_storyblok.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) => type //
      .invokeNamed("fromJson", referJSONMap().invokeNamed("from", valueExpression));
}
