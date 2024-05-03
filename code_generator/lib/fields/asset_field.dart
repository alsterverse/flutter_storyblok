import 'package:flutter_storyblok/asset.dart';
import 'package:flutter_storyblok/utils.dart';

import 'package:flutter_storyblok_code_generator/fields/base_field.dart';

final class AssetField extends BaseField {
  AssetField.fromJson(super.data, super.name)
      : assetTypes = List.from(data["filetypes"] ?? [] ),
        super.fromJson();
  final List<String> assetTypes;

  @override
  String symbol() {
    if (assetTypes.length == 1) {
      final assetType = assetTypes.first;
      return switch (assetType) {
        "images"  => "$ImageAsset",
        "videos" => "$VideoAsset",
        _ => "$Asset"
      };
    }
    else {
      return "$Asset";
    }
  }

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}.fromJson($JSONMap.from($valueCode))";
  }
}
