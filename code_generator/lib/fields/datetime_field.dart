import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/utils/code_builder.dart';

final class DateTimeField extends BaseField {
  DateTimeField.fromJson(super.data, super.name) : super.fromJson();

  @override
  TypeReference get type => referType(
        "$DateTime",
        nullable: !isRequired,
      );

  @override
  Expression buildInitializer(CodeExpression valueExpression) =>
      type.invokeNamed(isRequired ? "parse" : "tryParse", valueExpression);
}
