import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter_storyblok/utils.dart';

import 'package:flutter_storyblok_code_generator/http_client.dart';
import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/utils/data_models.dart';
import 'package:flutter_storyblok_code_generator/utils/enum.dart';
import 'package:flutter_storyblok_code_generator/utils/names.dart';

class StoryblokCodegen {
  final _dartFormatter = DartFormatter(fixes: StyleFix.all, pageWidth: 120);
  final _dartEmitter = DartEmitter.scoped(orderDirectives: true, useNullSafetySyntax: true);

  StoryblokCodegen({
    required List<DatasourceWithEntries> datasourceWithEntries,
    required this.components,
  }) : datasourceData = Map.fromEntries(datasourceWithEntries.map((e) {
          final (:datasource, :entries) = e;
          final name = sanitizeName(datasource.slug, isClass: true);
          return MapEntry(name, buildEnum(name, entries.map((e) => MapEntry(e.name, e.value))));
        }));

  // Key is the datasource slug
  final Map<String, Enum> datasourceData;
  final List<Component> components;

  Future<String> generate() async {
    final lib = LibraryBuilder();
    lib.name = "bloks";
    lib.generatedByComment = "storyblok_code_generator";

    // lint ...
    lib.ignoreForFile.add("unused_import");

    // import ...
    lib.directives.addAll([
      Directive.import('package:flutter_storyblok/asset.dart'),
      Directive.import('package:flutter_storyblok/link.dart'),
      Directive.import('package:flutter_storyblok/markdown.dart'),
      Directive.import('package:flutter_storyblok/request_parameters.dart'),
      Directive.import('package:flutter_storyblok/rich_text.dart'),
      Directive.import('package:flutter_storyblok/table.dart'),
      Directive.import('package:flutter_storyblok/plugin.dart'),
    ]);

    final components = await _buildComponents(lib);

    // enum <name> {
    lib.body.addAll(datasourceData.values);

    // class UnrecognizedBlok
    final unrecognizedBlokClass = ClassBuilder()..name = "UnrecognizedBlok";

    // sealed class Blok {
    final blokClass = Class((c) {
      c.docs.add("/// This class is generated, do not edit manually");
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
              ..body = Code([
                'switch (json["component"] as String) {',
                ...components.map((e) => 'case "${e.key}": return ${e.builder.name}.fromJson(json);'),
                'default: print("Unrecognized type \$\{json["component"]\}"); return ${unrecognizedBlokClass.name}();',
                '}',
              ].join("\n"))
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
      c.extend = refer(blokClass.name);
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
        ..type = refer("$JSONMap")
        ..name = "json"));

      for (final entry in schema.entries) {
        final name = entry.key;
        final fieldName = sanitizeName(name, isClass: false);
        final data = entry.value as JSONMap;
        final type = data["type"] as String;

        final field = BaseField.fromData(data, type, fieldName);
        if (field == null) {
          print("Unrecognized type $type");
          continue;
        }

        // TODO: External JSON should be unique to the url not the field.
        final supportingClass = await field.generateSupportingClass();
        if (supportingClass != null) lib.body.add(supportingClass);

        c.fields.add(Field((f) {
          f.type = TypeReference(field.buildFieldType);
          f.modifier = FieldModifier.final$;
          f.name = fieldName;
        }));

        con.initializers.add(Code(
          "$fieldName = ${field.generateInitializerCode('json["$name"]')}",
        ));
      }
      c.constructors.add(con.build());
      return (key: component.name, builder: c);
    }).toList();

    return Future.wait(list);
  }
}