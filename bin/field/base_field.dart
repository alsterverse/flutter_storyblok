import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/utils.dart';

import 'asset_field.dart';
import 'blok_fields.dart';
import 'boolean_field.dart';
import 'datetime_field.dart';
import 'link_field.dart';
import 'multi_asset_field.dart';
import 'number_field.dart';
import 'option_field.dart';
import 'text/text_area_field.dart';
import 'text/text_field.dart';
import 'text/text_markdown_field.dart';

abstract class BaseField {
  final JSONMap data;
  final String name;
  final bool isRequired;
  final int? position;
  BaseField(this.data, this.name, this.isRequired, this.position);
  BaseField.fromJson(this.data, this.name)
      : isRequired = tryCast<bool>(data["required"]) ?? false,
        position = tryCast<int>(data["pos"]);

  static BaseField? fromData(JSONMap data, String type, String fieldName) {
    return switch (type) {
      "bloks" => BlokField.fromJson(data, fieldName),
      "text" => TextField.fromJson(data, fieldName),
      "textarea" => TextAreaField.fromJson(data, fieldName),
      "markdown" => MarkdownField.fromJson(data, fieldName),
      "number" => NumberField.fromJson(data, fieldName),
      "boolean" => BooleanField.fromJson(data, fieldName),
      "datetime" => DateTimeField.fromJson(data, fieldName),
      "asset" => AssetField.fromJson(data, fieldName),
      "multiasset" => MultiAssetField.fromJson(data, fieldName),
      "multilink" => LinkField.fromJson(data, fieldName),
      "option" => OptionField.fromJson(data, fieldName),
      // "options" => OptionField.fromJson(data, fieldName),
      // table
      // plugin
      // rich
      _ => null,
    };
  }

  String symbol();

  void buildFieldType(TypeReferenceBuilder t) => t
    ..symbol = symbol()
    ..isNullable = !isRequired;

  List<Spec>? generateSupportingClasses() => null;

  String generateInitializerCode(String valueCode) => valueCode;
}
