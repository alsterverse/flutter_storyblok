import 'package:flutter_storyblok_code_generator/fields/base_field.dart';

class TextField extends BaseField {
  TextField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$String";
}
