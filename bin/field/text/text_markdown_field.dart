import 'package:flutter_storyblok/markdown.dart';

import '../base_field.dart';

final class MarkdownField extends BaseField {
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
