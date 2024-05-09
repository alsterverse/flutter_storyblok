import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/plugin.dart';
import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/utils/code_builder.dart';

// FieldType enum can not be generated beacuse FieldTypes API returns all available plugins for a user, not the project.

final class PluginField extends BaseField {
  PluginField.fromJson(super.data, super.name) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$Plugin",
    importUrl: 'package:flutter_storyblok/plugin.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    final expression = type.invokeNamed("fromJson", valueExpression);
    if (isRequired) return expression;
    return valueExpression.isNotA(refer("$Map")).conditional(literalNull, expression);
  }
}
