import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok_code_generator/src/utils/sanitize_name.dart';
import 'package:flutter_storyblok_code_generator/src/utils/code_builder_extensions.dart';
import 'package:flutter_storyblok_code_generator/src/utils/utils.dart';

({ClassBuilder sealedClass, List<Class> classes}) buildBloksSealedClass({
  required String name,
  List<TypeReference> genericTypes = const [],
  required List<({String key, ClassBuilder builder, Code Function(Expression) initializer})> classes,
  required bool throwUnrecognized,
}) {
  final sealedClassName = sanitizeName(name, isClass: true);
  final unrecognizedBlokClass = throwUnrecognized
      ? null
      : (ClassBuilder()
        ..name = "Unrecognized$sealedClassName"
        ..constructors.add(Constructor((con) => con..constant = true)));
  classes = classes.map((e) {
    e.builder.name = sanitizeName(e.builder.name!, isClass: true);
    return e;
  }).toList();

  final sealedClass = ClassBuilder()
    ..sealed = true
    ..name = sealedClassName
    ..types.addAll(genericTypes)
    ..constructors.add(Constructor((con) => con.constant = true));

  sealedClass.constructors.add(Constructor((con) {
    final unrecognizedTypeMessage = literalString("Unrecognized type '\$type' For class '$sealedClassName'");
    con
      ..factory = true
      ..name = "fromJson"
      ..requiredParameters.add(Parameter((p) => p
            ..type = refer("$JSONMap")
            ..name = "json"
          //
          ))
      ..body = Block.of([
        declareFinal("type").assign("json[${literal("component")}]".expression).statement,
        "return switch (type) {".code,
        ...classes
            .map((e) => [
                  "${literal(e.key)} => ".code,
                  e.initializer("${e.builder.name}.fromJson(json)".expression),
                  ",".code,
                ])
            .expand((e) => e),
        if (unrecognizedBlokClass == null) ...[
          "_ => ".code,
          unrecognizedTypeMessage.thrown.code,
        ] else ...[
          "_ => (){".code,
          "  print".expression.invoke(unrecognizedTypeMessage).statement,
          "  return const ${unrecognizedBlokClass.name}()".statement,
          "}()".code,
        ],
        "}".statement,
      ]);
  }));

  return (
    sealedClass: sealedClass,
    classes: [
      if (unrecognizedBlokClass != null) unrecognizedBlokClass,
      ...classes.map((e) => e.builder),
    ]
        .map((c) => c
          ..modifier = ClassModifier.final$
          ..extend = sealedClass.name!.reference())
        .map((e) => e.build())
        .toList(),
  );
}
