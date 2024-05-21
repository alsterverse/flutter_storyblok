import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

final class MarkdownField extends BaseField {
  MarkdownField.fromJson(super.data) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$Markdown",
    importUrl: 'package:flutter_storyblok/flutter_storyblok.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) =>
      initializerFromRequired(isRequired, valueExpression, type.invoke(valueExpression));
}
