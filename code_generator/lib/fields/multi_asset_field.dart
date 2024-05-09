import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/asset.dart';

import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/utils/code_builder.dart';

final class MultiAssetField extends BaseField {
  MultiAssetField.fromJson(super.data, super.name) : super.fromJson();

  late final TypeReference _type = referType(
    "$Asset",
    importUrl: 'package:flutter_storyblok/asset.dart',
    nullable: false,
  );

  @override
  late final TypeReference type = referList(type: _type);

  @override
  Expression buildInitializer(CodeExpression valueExpression) => referList(type: referJSONMap()) //
      .invokeNamed("from", valueExpression.ifNullThen(literalEmptyList()))
      .invokeNamed("map", _type.property("fromJson"))
      .invokeNamed("toList");
}
