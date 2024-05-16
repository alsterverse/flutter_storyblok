import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

final class AssetField extends BaseField {
  AssetField.fromJson(super.data)
      : assetTypes = List.from(data["filetypes"] ?? []),
        super.fromJson();
  final List<String> assetTypes;

  @override
  late final TypeReference type = referType(
    switch (assetTypes.length == 1 ? assetTypes.first : null) {
      "images" => "$ImageAsset",
      "videos" => "$VideoAsset",
      "audios" => "$AudioAsset",
      "texts" => "$TextAsset",
      _ => "$Asset",
    },
    importUrl: 'package:flutter_storyblok/flutter_storyblok.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    final initializer = type.invokeNamed("fromJson", valueExpression);
    return isRequired
        ? initializer //
        : valueExpression.equalTo(literalNull).conditional(literalNull, initializer);
  }
}
