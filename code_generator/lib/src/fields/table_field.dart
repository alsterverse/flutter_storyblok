import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/fields.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

final class TableField extends BaseField {
  TableField.fromJson(super.data) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$Table",
    importUrl: 'package:flutter_storyblok/fields.dart',
    nullable: false,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) => type.invokeNamed("fromJson", valueExpression);
}
