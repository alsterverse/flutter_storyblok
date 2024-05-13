import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

import 'base_field.dart';
import '../utils/code_builder.dart';

final class TableField extends BaseField {
  TableField.fromJson(super.data, super.name) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$Table",
    importUrl: 'package:flutter_storyblok/flutter_storyblok.dart',
    nullable: false,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) => type.invokeNamed("fromJson", valueExpression);
}
