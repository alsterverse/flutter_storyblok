import 'package:code_builder/code_builder.dart';

import 'package:flutter_storyblok_code_generator/fields/base_field.dart';

final class BooleanField extends BaseField {
  BooleanField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$bool";

  @override
  void buildFieldType(TypeReferenceBuilder t) {
    super.buildFieldType(t);
    t.isNullable = false;
  }

  @override
  String generateInitializerCode(String valueCode) => "$valueCode${isRequired ? "" : " ?? false"}";
}
