import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok_code_generator/src/code_emitter.dart';

import 'fields/base_field.dart';
import 'http_client.dart';
import 'data_models.dart';
import 'enum.dart';
import 'names.dart';
import 'utils/code_builder_extensions.dart';
import 'utils/utils.dart';

class StoryblokCodegen {
  StoryblokCodegen({
    required this.getDatasourceFromExternalSource,
    required List<DatasourceWithEntries> datasourceWithEntries,
    required this.components,
  }) : datasourceData = datasourceWithEntries.map((e) {
          final (:datasource, :entries) = e;
          return buildEnum(datasource.slug, entries.map((e) => MapEntry(e.name, e.value)));
        }).toList();

  final Future<List<JSONMap>> Function(Uri) getDatasourceFromExternalSource;
  final List<Enum> datasourceData;
  final List<Component> components;
  final codeEmitter = CodeEmitter();

  Future<String> generate() async {
    final lib = LibraryBuilder();
    lib.name = "bloks";
    lib.generatedByComment = "flutter_storyblok_code_generator";
    lib.ignoreForFile.add("unused_import");

    final components = await _buildComponents(lib);

    // enum <name> {
    lib.body.addAll(datasourceData);

    // class UnrecognizedBlok
    final unrecognizedBlokClass = ClassBuilder()..name = "UnrecognizedBlok";

    // sealed class Blok {
    final blokClass = Class((c) {
      c.docs.add("/// This is the base class for all blocks defined in \"Block Library\"");
      c.sealed = true;
      c.name = "Blok";
      c.constructors.add(Constructor());
      // Blok.fromJson(JSONMap json) {
      c.constructors.add(Constructor((con) => con
            ..factory = true
            ..name = "fromJson"
            ..requiredParameters.add(Parameter((p) => p
                  ..type = refer("$JSONMap")
                  ..name = "json"
                //
                ))
            ..body = Block.of([
              "return switch (json[${literal("component")}] as $String) {",
              ...components.map(
                (e) => "${literal(e.key)} => ${e.builder.name}.fromJson(json),",
              ),
              "_ => (){",
              "print('Unrecognized type \${json[${literal("component")}]}');",
              "return ${unrecognizedBlokClass.name}();",
              "}()",
              "};",
            ].map(Code.new))
          //
          ));
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
    return codeEmitter.codeFromSpec(library);
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

        final field = BaseField.fromData(data, type: type, fieldName: fieldName, ownerName: c.name!);
        if (field == null) {
          if (!["section", "tab"].contains(type)) print("Unrecognized type $type");
          continue;
        }
        if (field.shouldSkip) {
          continue;
        }

        // TODO: External JSON should be unique to the url not the field.
        final supportingClass = await field.buildSupportingClass(getDatasourceFromExternalSource);
        if (supportingClass != null) lib.body.add(supportingClass);

        c.fields.add(field.build(fieldName));

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
