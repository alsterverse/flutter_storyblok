import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

final class MultiAssetField extends BaseField {
  MultiAssetField.fromJson(super.data) : super.fromJson();

  late final TypeReference _type = referType(
    "$Asset",
    importUrl: 'package:flutter_storyblok/flutter_storyblok.dart',
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
