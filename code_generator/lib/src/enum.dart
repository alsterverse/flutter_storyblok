import 'package:code_builder/code_builder.dart';

import 'names.dart';
import 'utils/code_builder.dart';

const _unknownName = "unknown";
const _fromNameName = "fromName";

Expression buildInstantiateEnum(String className, [String? code]) {
  var exp = referType(sanitizeName(className, isClass: true)).property(_fromNameName);
  if (code != null) {
    exp = exp.invoke(code.expression);
  }
  return exp;
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
            ..arguments.add(literal(kase.value))
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
                  ..type = referType("$String?")
                  ..name = "name"
                //
                ))
            ..body = Block.of([
              "return switch (name) {",
              ...caseNames.map(
                (e) => "${literal(e.value)} => $className.${sanitizeName(e.key, isClass: false)},",
              ),
              "_ => $className.$_unknownName,",
              "};",
            ].map(Code.new))
          //
          )),
  );
}
