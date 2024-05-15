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
  final bool isRequired;
  final int? position;
  BaseField(this.data, this.isRequired, this.position);
  BaseField.fromJson(this.data)
      : isRequired = data["required"] ?? false,
        position = data["pos"];

  static BaseField? fromData(
    JSONMap data, {
    required String type,
    required String fieldName,
    required String ownerName,
  }) {
    return switch (type) {
      "bloks" => BlokField.fromJson(data),
      "text" => TextField.fromJson(data),
      "textarea" => TextAreaField.fromJson(data),
      "markdown" => MarkdownField.fromJson(data),
      "number" => NumberField.fromJson(data),
      "boolean" => BooleanField.fromJson(data),
      "datetime" => DateTimeField.fromJson(data),
      "asset" => AssetField.fromJson(data),
      "multiasset" => MultiAssetField.fromJson(data),
      "multilink" => LinkField.fromJson(data),
      "option" => OptionField.fromJson(data, fieldName, ownerName),
      "options" => OptionsField.fromJson(data, fieldName, ownerName),
      "table" => TableField.fromJson(data),
      "custom" => PluginField.fromJson(data),
      "richtext" => RichTextField.fromJson(data),
      _ => null,
    };
  }

  TypeReference get type;

  Expression buildInitializer(CodeExpression valueExpression) => valueExpression;

  Future<Spec?> buildSupportingClass() => Future.value(null);

  Field build(String fieldName) {
    return Field((f) => f
          ..type = type
          ..modifier = FieldModifier.final$
          ..name = fieldName
        //
        );
  }
}
