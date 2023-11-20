import 'package:flutter_storyblok/asset.dart';
import 'package:flutter_storyblok/utils.dart';

import 'base_field.dart';

final class AssetField extends BaseField {
  AssetField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$Asset";

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}.fromJson($JSONMap.from($valueCode))";
  }
}
