import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/fields.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

base class AssetField extends BaseField {
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
    importUrl: 'package:flutter_storyblok/fields.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) =>
      initializerFromRequired(isRequired, valueExpression, type.nonNullable.invokeNamed("fromJson", valueExpression));
}
