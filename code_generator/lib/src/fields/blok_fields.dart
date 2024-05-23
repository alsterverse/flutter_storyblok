import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok_code_generator/src/sealed.dart';
import 'package:flutter_storyblok_code_generator/src/utils/utils.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';
import '../names.dart';

final class BlokField extends BaseField {
  final int? maximum;
  final bool restrictTypes;
  final List<String> restrictedTypes;
  final String restrictedTypesClassName;
  BlokField.fromJson(super.data, String fieldName, String owner)
      : maximum = data["maximum"],
        restrictTypes = data["restrict_components"] ?? false,
        restrictedTypes = List.from(data["component_whitelist"] ?? []),
        restrictedTypesClassName = "${owner}_${fieldName}_RestrictedTypes",
        super.fromJson();

  late final _isSingle = maximum == 1;
  late final _isRestricted = restrictTypes && restrictedTypes.isNotEmpty;
  late final _useRestrictedSealedClass = _isRestricted && restrictedTypes.length > 1;

  late final TypeReference _type = referType(_isRestricted //
      ? sanitizeName(_useRestrictedSealedClass ? restrictedTypesClassName : restrictedTypes.first, isClass: true)
      : "Blok");

  @override
  late final TypeReference type = _isSingle //
      ? _type.rebuild((t) => t.isNullable = !isRequired)
      : referList(type: _type);

  @override
  Future<List<Spec>?> buildSupportingClass(Future<List<JSONMap>> Function(Uri) getExternalSource) {
    if (!_useRestrictedSealedClass) return super.buildSupportingClass(getExternalSource);

    final (:sealedClass, :classes) = buildBloksSealedClass(
      name: restrictedTypesClassName,
      classes: restrictedTypes.map((e) {
        final field = Field((f) => f
          ..modifier = FieldModifier.final$
          ..type = sanitizeName(e, isClass: true).reference()
          ..name = sanitizeName(e, isClass: false));
        return (
          key: e,
          builder: ClassBuilder()
            ..name = "${restrictedTypesClassName}_$e"
            ..fields.add(field)
            ..constructors.add(Constructor((con) => con
                  ..name = "fromJson"
                  ..requiredParameters.add(Parameter((p) => p
                    ..type = "$JSONMap".reference()
                    ..name = "json"))
                  ..initializers
                      .add(field.name.expression.assign(field.type!.invokeNamed("fromJson", refer("json"))).code)
                //
                )),
          initializer: (Expression expression) => expression.code,
        );
      }).toList(),
      throwUnrecognized: true,
    );
    return Future.value([sealedClass.build(), ...classes]);
  }

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    var expression = referList(type: referJSONMap())
        .invokeNamed("from", valueExpression.ifNullThen(literalEmptyList()))
        .invokeNamed("map", _type.property("fromJson"))
        .invokeNamed("toList");

    if (_isSingle) {
      // TODO: Needs to import collection package... Seems to be working without though ???
      expression = expression.property(isRequired ? "first" : "firstOrNull");
    }
    return expression;
  }
}
