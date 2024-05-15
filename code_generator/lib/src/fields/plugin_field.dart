import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

// FieldType enum can not be generated beacuse FieldTypes API returns all available plugins for a user, not the project.

final class PluginField extends BaseField {
  PluginField.fromJson(super.data) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$Plugin",
    importUrl: 'package:flutter_storyblok/flutter_storyblok.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    final expression = type.invokeNamed("fromJson", valueExpression);
    if (isRequired) return expression;
    return valueExpression.isNotA(refer("$Map")).conditional(literalNull, expression);
  }
}
