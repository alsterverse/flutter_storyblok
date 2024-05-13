import 'package:code_builder/code_builder.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';
import '../names.dart';

final class BlokField extends BaseField {
  final int? maximum;
  final bool restrictTypes;
  final List<String> restrictedTypes;
  BlokField.fromJson(super.data, super.name)
      : maximum = data["maximum"],
        restrictTypes = data["restrict_components"] ?? false,
        restrictedTypes = List.from(data["component_whitelist"] ?? []),
        super.fromJson();

  late final TypeReference _type = referType((restrictTypes && restrictedTypes.length == 1) //
          ? sanitizeName(restrictedTypes.first, isClass: true)
          : "Blok"
      //
      );

  @override
  late final TypeReference type = (maximum == 1 //
          ? _type
          : referList(type: _type))
      .rebuild((t) => t.isNullable = !isRequired);

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    var expression = referList(type: referJSONMap())
        .invokeNamed("from", valueExpression.ifNullThen(literalEmptyList()))
        .invokeNamed("map", _type.property("fromJson"))
        .invokeNamed("toList");

    if (maximum == 1) {
      // TODO: Needs to import collection package
      expression = expression.property(isRequired ? "first" : "firstOrNull");
    }
    return expression;
  }
}
