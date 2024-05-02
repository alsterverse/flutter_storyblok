import 'package:flutter_storyblok/utils.dart';

import 'package:flutter_storyblok_code_generator/fields/base_field.dart';

final class NumberField extends BaseField {
  final int? decimals;
  NumberField.fromJson(super.data, super.name)
      : decimals = tryCast<int>(data["decimals"]),
        super.fromJson();

  @override
  String symbol() => decimals == 0 ? "$int" : "$double";

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}.${isRequired ? "parse" : "tryParse"}($valueCode)";
  }
}
