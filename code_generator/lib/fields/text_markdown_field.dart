import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/markdown.dart';

import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/utils/code_builder.dart';

final class MarkdownField extends BaseField {
  MarkdownField.fromJson(super.data, super.name) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$Markdown",
    importUrl: 'package:flutter_storyblok/markdown.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) => type.invoke(valueExpression);
}
