import 'package:dart_casing/dart_casing.dart';
import 'package:flutter_storyblok/utils.dart';

import 'base_field.dart';

final class BlokField extends BaseField {
  final int? maximum;
  final bool restrictTypes;
  final List<String> restrictedTypes;
  BlokField.fromJson(super.data, super.name)
      : maximum = data["maximum"],
        restrictTypes = data["restrict_components"] ?? false,
        restrictedTypes = List.from(data["component_whitelist"] ?? []),
        super.fromJson();

  String _type() {
    if (restrictTypes && restrictedTypes.length == 1) {
      return Casing.pascalCase(restrictedTypes.first);
    } else {
      return "Blok";
    }
  }

  @override
  String symbol() => maximum == 1 ? _type() : "List<${_type()}>";

  @override
  String generateInitializerCode(String valueCode) {
    final code = "${List<JSONMap>}.from($valueCode).map(${_type()}.fromJson).toList()"; // TODO Nullable
    return maximum == 1 ? "$code.first" : code;
  }
}
