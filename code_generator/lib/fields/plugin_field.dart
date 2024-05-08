import 'package:flutter_storyblok/plugin.dart';
import 'package:flutter_storyblok_code_generator/fields/base_field.dart';

// FieldType enum can not be generated beacuse FieldTypes API returns all available plugins for a user, not the project.

final class PluginField extends BaseField {
  PluginField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() {
    return "$Plugin";
  }

  @override
  String generateInitializerCode(String valueCode) {
    return "${isRequired ? "" : "$valueCode is! Map ? null : "}${symbol()}.fromJson($valueCode)";
  }
}
