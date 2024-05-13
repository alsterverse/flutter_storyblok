import 'package:code_builder/code_builder.dart';

import 'asset_field.dart';
import 'blok_fields.dart';
import 'boolean_field.dart';
import 'datetime_field.dart';
import 'link_field.dart';
import 'multi_asset_field.dart';
import 'number_field.dart';
import 'option_field.dart';
import 'options_field.dart';
import 'rich_text_field.dart';
import 'table_field.dart';
import 'text_area_field.dart';
import 'text_field.dart';
import 'text_markdown_field.dart';
import 'plugin_field.dart';
import '../utils/utils.dart';

abstract base class BaseField {
  final JSONMap data;
  final String name;
  final bool isRequired;
  final int? position;
  BaseField(this.data, this.name, this.isRequired, this.position);
  BaseField.fromJson(this.data, this.name)
      : isRequired = data["required"] ?? false,
        position = data["pos"];

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
      "table" => TableField.fromJson(data, fieldName),
      "options" => OptionsField.fromJson(data, fieldName),
      "custom" => PluginField.fromJson(data, fieldName),
      "richtext" => RichTextField.fromJson(data, fieldName),
      _ => null,
    };
  }

  TypeReference get type;

  void buildField(FieldBuilder f) {
    f.name = name;
    f.type = type;
  }

  Expression buildInitializer(CodeExpression valueExpression) => valueExpression;

  Future<Spec?> buildSupportingClass() => Future.value(null);
}
