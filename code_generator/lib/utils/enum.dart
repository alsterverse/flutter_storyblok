import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok_code_generator/utils/names.dart';

const _unknownName = "unknown";
const _fromNameName = "fromName";

String buildInstantiateEnum(String className, [String? code]) {
  return "${cachedSanitizedName(className, isClass: true)}.$_fromNameName${code == null ? "" : "($code)"}";
}

Enum buildEnum(String className, Iterable<MapEntry<String, String>> caseNames) {
  className = sanitizeName(unsanitizedName(className), isClass: true);
  caseNames = caseNames.where((element) => element.value.isNotEmpty);
  return Enum(
    (e) => e
      ..name = className
      ..fields.add(Field((f) => f
            ..modifier = FieldModifier.final$
            ..name = "raw"
            ..type = refer("$String")
          //
          ))
      ..values.addAll(<MapEntry<String, String>>[
        ...caseNames,
        MapEntry(_unknownName, _unknownName),
      ].map((kase) => EnumValue((v) => v
            ..name = sanitizeName(kase.key, isClass: false)
            ..arguments.add(literalString("${kase.value}"))
          //
          )))
      ..constructors.add(Constructor((con) => con
            ..constant = true
            ..requiredParameters.add(Parameter((p) => p
                  ..toThis = true
                  ..name = "raw"
                //
                ))
          //
          ))
      ..constructors.add(Constructor((m) => m
            ..factory = true
            ..name = _fromNameName
            ..requiredParameters.add(Parameter((p) => p
                  ..type = refer("$String?")
                  ..name = "name"
                //
                ))
            ..body = Code([
              "return switch (name) {",
              ...caseNames.map(
                (e) => '"${e.value}" => $className.${cachedSanitizedName(e.key, isClass: false)},',
              ),
              "_ => $className.$_unknownName,",
              "};",
            ].join("\n"))
          //
          )),
  );
}
