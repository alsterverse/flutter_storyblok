import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/table.dart';
import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/utils/code_builder.dart';

final class TableField extends BaseField {
  TableField.fromJson(super.data, super.name) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$Table",
    importUrl: 'package:flutter_storyblok/table.dart',
    nullable: false,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) => type.invokeNamed("fromJson", valueExpression);
}
