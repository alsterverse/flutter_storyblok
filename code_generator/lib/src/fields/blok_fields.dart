import 'package:code_builder/code_builder.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';
import '../names.dart';

final class BlokField extends BaseField {
  final int? maximum;
  final bool restrictTypes;
  final List<String> restrictedTypes;
  BlokField.fromJson(super.data)
      : maximum = data["maximum"],
        restrictTypes = data["restrict_components"] ?? false,
        restrictedTypes = List.from(data["component_whitelist"] ?? []),
        super.fromJson();

  late final _isSingle = maximum == 1;
  late final _isRestricted = restrictTypes && restrictedTypes.length == 1;

  late final TypeReference _type = referType(_isRestricted //
      ? sanitizeName(restrictedTypes.first, isClass: true)
      : "Blok");

  @override
  late final TypeReference type = (_isSingle //
          ? _type
          : referList(type: _type))
      .rebuild((t) => t.isNullable = _isSingle && !isRequired);

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
