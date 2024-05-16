import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok_code_generator/src/fields/asset_field.dart';

import '../utils/code_builder_extensions.dart';

final class MultiAssetField extends AssetField {
  MultiAssetField.fromJson(super.data) : super.fromJson();

  late final _type = super.type.nonNullable;

  @override
  TypeReference get type => referList(type: _type);

  @override
  Expression buildInitializer(CodeExpression valueExpression) => referList(type: referJSONMap()) //
      .invokeNamed("from", valueExpression.ifNullThen(literalEmptyList()))
      .invokeNamed("map", _type.property("fromJson"))
      .invokeNamed("toList");
}
