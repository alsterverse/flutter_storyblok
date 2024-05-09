import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/utils/code_builder.dart';

class TextField extends BaseField {
  TextField.fromJson(super.data, super.name) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$String",
    nullable: !isRequired,
  );
}
