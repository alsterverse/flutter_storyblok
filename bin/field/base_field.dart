import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/utils.dart';

abstract class BaseField {
  final JSONMap data;
  final String name;
  final bool isRequired;
  final int? position;
  BaseField(this.data, this.name, this.isRequired, this.position);
  BaseField.fromJson(this.data, this.name)
      : isRequired = tryCast<bool>(data["required"]) ?? false,
        position = tryCast<int>(data["pos"]);

  String symbol();

  void buildFieldType(TypeReferenceBuilder t) => t
    ..symbol = symbol()
    ..isNullable = !isRequired;

  void buildField(FieldBuilder f) {
    f.name = name;
    f.type = TypeReference(buildFieldType);
  }

  List<Spec>? generateSupportingClasses() => null;

  String generateInitializerCode(String valueCode) => valueCode;
}
