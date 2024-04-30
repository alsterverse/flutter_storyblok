import 'package:code_builder/code_builder.dart';
import 'package:dart_casing/dart_casing.dart';

import '../storyblok_sourcegen.dart';

const _unknownName = "unknown";
const _fromNameName = "fromName";

String buildInstantiateEnum(String className, String name) {
  return "$className.$_fromNameName('$name')";
}

Enum buildEnum(String name, Iterable<String> cases) {
  final className = Casing.pascalCase(name);
  cases = [...cases.where((element) => element.isNotEmpty), _unknownName];
  return Enum(
    (e) => e
      ..name = className
      ..fields.add(Field((f) => f
        ..modifier = FieldModifier.final$
        ..name = "raw"
        ..type = refer("$String")))
      ..values.addAll(
        cases.map((c) => EnumValue(
              (v) => v
                ..name = Casing.camelCase(c.startsWith(RegExp(incompatibleNameRegex)) ? '\$$c' : c)
                ..arguments.add(
                  literalString("$c"),
                ),
            )),
      )
      ..constructors.add(
        Constructor(
          (con) => con
            ..constant = true
            ..requiredParameters.add(Parameter((p) => p
              ..toThis = true
              ..name = "raw")),
        ),
      )
      ..constructors.add(Constructor((m) => m
        ..factory = true
        ..name = _fromNameName
        ..requiredParameters.add(Parameter(
          (p) => p
            ..type = refer("$String?")
            ..name = "name",
        ))
        ..body = Code(
          "return ${mapIfNotNullMethod.name}(name, (n) => $className.values.asNameMap()[n.startsWith(${incompatibleNameRegexField.name}) ? '\\\$\$n' : n]) ?? $className.$_unknownName;",
        ))),
  );
}
