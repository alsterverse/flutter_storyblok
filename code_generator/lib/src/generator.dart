import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'fields/base_field.dart';
import 'http_client.dart';
import 'data_models.dart';
import 'enum.dart';
import 'names.dart';
import 'utils/code_builder.dart';
import 'utils/utils.dart';

class StoryblokCodegen {
  final _dartFormatter = DartFormatter(fixes: StyleFix.all, pageWidth: 120);
  final _dartEmitter = DartEmitter.scoped(orderDirectives: true, useNullSafetySyntax: true);

  StoryblokCodegen({
    required List<DatasourceWithEntries> datasourceWithEntries,
    required this.components,
  }) : datasourceData = datasourceWithEntries.map((e) {
          final (:datasource, :entries) = e;
          return buildEnum(datasource.slug, entries.map((e) => MapEntry(e.name, e.value)));
        }).toList();

  // Key is the datasource slug
  final List<Enum> datasourceData;
  final List<Component> components;

  Future<String> generate() async {
    final lib = LibraryBuilder();
    lib.name = "bloks";
    lib.generatedByComment = "storyblok_code_generator";

    // lint ...
    lib.ignoreForFile.add("unused_import");

    final components = await _buildComponents(lib);

    // enum <name> {
    lib.body.addAll(datasourceData);

    // class UnrecognizedBlok
    final unrecognizedBlokClass = ClassBuilder()..name = "UnrecognizedBlok";

    // sealed class Blok {
    final blokClass = Class((c) {
      c.docs.add("/// This class is generated, do not edit manually");
      c.modifier = ClassModifier.final$;
      c.sealed = true;
      c.name = "Blok";
      c.constructors.addAll([
        Constructor(),
        // Blok.fromJson(JSONMap json) {
        Constructor((con) => con
              ..factory = true
              ..name = "fromJson"
              ..requiredParameters.add(Parameter((p) => p
                    ..type = refer("$JSONMap")
                    ..name = "json"
                  //
                  ))
              ..body = Block.of([
                "switch (json[${literal("component")}] as String) {",
                ...components.map(
                  (e) => "case ${literal(e.key)}: return ${e.builder.name}.fromJson(json);",
                ),
                "default:",
                "print('Unrecognized type \${json[${literal("component")}]}');",
                "return ${unrecognizedBlokClass.name}();",
                "}",
              ].map(Code.new))
            //
            ),
      ]);
    });
    lib.body.add(blokClass);

    // final class <name> extends Blok {
    lib.body.addAll([
      ...components.map((e) => e.builder),
      unrecognizedBlokClass,
    ].map((c) {
      c.modifier = ClassModifier.final$;
      c.extend = blokClass.name.reference();
      return c.build();
    }));

    final library = lib.build();
    final a = library.accept(_dartEmitter);
    return _dartFormatter.format(a.toString());
  }

  Future<List<({String key, ClassBuilder builder})>> _buildComponents(LibraryBuilder lib) {
    final list = components.map((component) async {
      final c = ClassBuilder();
      c.name = sanitizeName(component.name, isClass: true);
      final schema = component.schema;

      final con = ConstructorBuilder();
      con.name = "fromJson";
      con.requiredParameters.add(Parameter((p) => p
        ..type = "$JSONMap".reference()
        ..name = "json"));

      // fields
      for (final entry in schema.entries) {
        final name = entry.key;
        final fieldName = sanitizeName(name, isClass: false);
        final data = entry.value as JSONMap;
        final type = data["type"] as String;

        final field = BaseField.fromData(data, type, fieldName);
        if (field == null) {
          if (type != "group") print("Unrecognized type $type");
          continue;
        }

        // TODO: External JSON should be unique to the url not the field.
        final supportingClass = await field.buildSupportingClass();
        if (supportingClass != null) lib.body.add(supportingClass);

        c.fields.add(Field((f) {
          f.type = field.type;
          f.modifier = FieldModifier.final$;
          f.name = fieldName;
        }));

        con.initializers.add(
          fieldName.expression.assign(field.buildInitializer("json[${literal(name)}]".expression)).code,
        );
      }
      c.constructors.add(con.build());
      return (key: component.name, builder: c);
    }).toList();

    return Future.wait(list);
  }
}
