import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/fields.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

// FieldType enum can not be generated beacuse FieldTypes API returns all available plugins for a user, not the project.

final class PluginField extends BaseField {
  PluginField.fromJson(super.data)
      : fieldType = data["field_type"],
        super.fromJson();

  final String? fieldType;

  @override
  bool get shouldSkip => fieldType == null;

  @override
  late final TypeReference type = referType(
    "$Plugin",
    importUrl: 'package:flutter_storyblok/fields.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    final expression = type.property('fromJson').call([valueExpression, literalString(fieldType!)]);
    if (isRequired) return expression;
    return valueExpression.isNotA(refer("$Map")).conditional(literalNull, expression);
  }
}
