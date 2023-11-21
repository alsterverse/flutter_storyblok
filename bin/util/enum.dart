import 'package:code_builder/code_builder.dart';
import 'package:dart_casing/dart_casing.dart';

Enum buildEnum(String name, Iterable<String> cases) {
  cases = [...cases, "unknown"];
  return Enum((e) => e
    ..name = Casing.pascalCase(name)
    ..values.addAll(
      cases.map((c) => EnumValue((v) => v..name = Casing.camelCase(c))),
    ));
}
