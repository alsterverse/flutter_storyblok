import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/rich_text.dart';
import 'package:flutter_storyblok_code_generator/utils/code_builder.dart';

import 'base_field.dart';

class RichTextField extends BaseField {
  RichTextField.fromJson(super.data, super.name) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$RichText",
    importUrl: 'package:flutter_storyblok/rich_text.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) => type.invokeNamed("fromJson", valueExpression);
}
