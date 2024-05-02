import 'package:flutter_storyblok/asset.dart';

import 'package:flutter_storyblok_code_generator/fields/base_field.dart';

final class MultiAssetField extends BaseField {
  MultiAssetField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "${List<Asset>}";

  @override
  String generateInitializerCode(String valueCode) {
    return "($valueCode as $List${isRequired ? ")" : "?)?"}.map((e) => $Asset.fromJson(e)).toList()";
  }
}
