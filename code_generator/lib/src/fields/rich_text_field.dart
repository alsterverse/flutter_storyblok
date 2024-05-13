import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

final class RichTextField extends BaseField {
  RichTextField.fromJson(super.data, super.name) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$RichText",
    importUrl: 'package:flutter_storyblok/flutter_storyblok.dart',
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) => type.invokeNamed("fromJson", valueExpression);
}
