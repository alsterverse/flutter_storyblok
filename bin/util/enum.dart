import 'package:code_builder/code_builder.dart';
import 'package:dart_casing/dart_casing.dart';

Enum buildEnum(String name, Iterable<String> cases) {
  final cn = Casing.pascalCase(name);
  cases = [...cases.where((element) => element.isNotEmpty), "unknown"];
  return Enum((e) => e
    ..name = cn
    ..values.addAll(
      cases.map((c) => EnumValue((v) => v
        ..name = Casing.camelCase(c.startsWith(RegExp('[^a-zA-Z]')) ? '\$$c' : c)
      )),
    )
    ..constructors.add(Constructor((c) => c
      ..constant = true
    ))
    ..methods.add(Method((m) => m
      ..static = true
      ..returns = Reference(cn)
      ..name = "fromName"
      ..requiredParameters.add(Parameter((p) => p
        ..type = Reference("$String")
        ..name = "name"
      ))
      ..body = Code("return $cn.values.asNameMap()[name.startsWith(_regex) ? '\\\$\$name' : name] ?? $cn.unknown;")
    )));
}
