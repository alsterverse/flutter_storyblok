import 'package:flutter_storyblok/rich_text.dart';

import 'base_field.dart';

class RichTextField extends BaseField {
  RichTextField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$RichText";

  @override
  String generateInitializerCode(String valueCode) => "$RichText.fromJson($valueCode)";
}
