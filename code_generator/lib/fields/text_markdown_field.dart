import 'package:flutter_storyblok/markdown.dart';
import 'package:flutter_storyblok_code_generator/fields/text_field.dart';

final class MarkdownField extends TextField {
  MarkdownField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() {
    return "$Markdown";
  }

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}($valueCode)";
  }
}
