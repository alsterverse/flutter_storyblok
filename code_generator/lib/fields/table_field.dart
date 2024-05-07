import 'package:code_builder/src/specs/type_reference.dart';
import 'package:flutter_storyblok/table.dart';
import 'package:flutter_storyblok_code_generator/fields/base_field.dart';

final class TableField extends BaseField {
  TableField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$Table";

  @override
  void buildFieldType(TypeReferenceBuilder t) {
    super.buildFieldType(t);
    t.isNullable = false;
  }

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}.fromJson($valueCode)";
  }
}
