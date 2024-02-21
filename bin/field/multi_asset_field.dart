import 'package:flutter_storyblok/asset.dart';

import 'base_field.dart';

final class MultiAssetField extends BaseField {
  MultiAssetField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "${List<Asset>}";

  @override
  String generateInitializerCode(String valueCode) {
    return "($valueCode as List<dynamic>${isRequired ? "" : " ?? []"}).map((e) => $Asset.fromJson(e)).toList()";
  }
}
