import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_casing/dart_casing.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter_storyblok/utils.dart';

import 'api.dart';
import 'field/base_field.dart';
import 'util/data_models.dart';
import 'util/enum.dart';

final dartFormatter = DartFormatter(fixes: StyleFix.all, pageWidth: 120);
final dartEmitter = DartEmitter.scoped(orderDirectives: true, useNullSafetySyntax: true);

// Key is the datasource slug
Map<String, Enum> datasourceData = {};

/// final _incompatibleNameRegex = RegExp('[^a-zA-Z]');
const incompatibleNameRegex = "[^a-zA-Z]";
final incompatibleNameRegexField = Field(
  (f) => f
    ..modifier = FieldModifier.final$
    ..name = "_incompatibleNameRegex"
    ..assignment = Code("RegExp('$incompatibleNameRegex')"),
);

/// Out? _mapIfNotNull<In, Out>(In?, Out? Function(In))
final mapIfNotNullMethod = Method(
  (m) => m
    ..returns = refer("Out?")
    ..name = "_mapIfNotNull"
    ..types = ListBuilder([refer("In"), refer("Out")])
    ..requiredParameters.addAll([
      Parameter((p) => p
        ..type = refer("In?")
        ..name = "value"),
      Parameter((p) => p
        ..type = refer("Out? Function(In)")
        ..name = "mapper"),
    ])
    ..body = Code("return value == null ? null : mapper(value);"),
);

void main(List<String> args) async {
  final spaceId = args[0];
  final authorization = args[1];
  final outputPath = args[2];

  final codegen = StoryblokCodegen(spaceId: spaceId, authorization: authorization, outputPath: outputPath);
  await codegen.generate();
}

class StoryblokCodegen {
  late final String _spaceId;
  late final String _authorization;
  late final String _outputPath;

  StoryblokCodegen({required String spaceId, required String authorization, required String outputPath}) {
    _spaceId = spaceId;
    _authorization = authorization;
    _outputPath = outputPath;
  }

  late final _apiClient = StoryblokHttpClient(_spaceId, _authorization);

  Future generate() async {
    final lib = LibraryBuilder();

    lib.comments.add("ignore_for_file: unused_import");

    // import ...
    lib.directives.addAll([
      Directive.import('package:flutter_storyblok/asset.dart'),
      Directive.import('package:flutter_storyblok/link_type.dart'),
      Directive.import('package:flutter_storyblok/markdown.dart'),
      Directive.import('package:flutter_storyblok/request_parameters.dart'),
    ]);

    lib.body.add(incompatibleNameRegexField);
    lib.body.add(mapIfNotNullMethod);

    await _downloadDatasource(); // Must be fetched before "components"
    final components = await _downloadComponents(lib);

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
        Constructor(
          (co) => co
            ..factory = true
            ..name = "fromJson"
            ..requiredParameters.add(
              Parameter((p) => p
                ..type = refer("$JSONMap")
                ..name = "json"),
            )
            ..body = Code([
              'switch (json["component"] as String) {',
              ...components.map((e) => 'case "${e.key}": return ${e.builder.name}.fromJson(json);'),
              'default: print("Unrecognized type \$\{json["component"]\}"); return ${unrecognizedBlokClass.name}();',
              '}',
            ].join("\n")),
        ),
        // }
      ]);
    });
    lib.body.add(blokClass);
    // }

    // final class <name> extends Blok {
    lib.body.addAll([
      ...components.map((e) => e.builder),
      unrecognizedBlokClass,
    ].map((c) {
      c.modifier = ClassModifier.final$;
      c.extend = refer(blokClass.name);
      return c.build();
    }));
    // }

    final output = dartFormatter.format(lib.build().accept(dartEmitter).toString());
    final file = File(_outputPath);
    if (file.existsSync()) file.deleteSync();
    file.writeAsStringSync(output);
  }

  // TODO Dimensions
  Future _downloadDatasource() async {
    final ds = await _apiClient.get("datasources");
    final datasources = List<JSONMap>.from(ds["datasources"]).map(Datasource.fromJson).toList();
    final allEntries = await Future.wait(datasources.map((e) async {
      final d = await _apiClient.get("datasource_entries", {"datasource_id": e.id.toString()});
      return List<JSONMap>.from(d["datasource_entries"]).map(DatasourceEntry.fromJson).toList();
    }));
    final mapped = datasources.mapIndexed((i, e) => (e, allEntries[i])).toList();

    for (final (d, entries) in mapped) {
      final name = d.slug;
      datasourceData[name] = buildEnum(name, entries.map((e) => e.value));
    }
  }

  Future<List<({String key, ClassBuilder builder})>> _downloadComponents(LibraryBuilder lib) async {
    final components = await _apiClient.getComponents();
    return components.map((component) {
      final c = ClassBuilder();
      c.name = Casing.pascalCase(component.name);
      final schema = component.schema;

      final con = ConstructorBuilder();
      con.name = "fromJson";
      con.requiredParameters.add(Parameter((p) => p
        ..type = refer("$JSONMap")
        ..name = "json"));

      for (final entry in schema.entries) {
        final name = entry.key;
        final fieldName = Casing.camelCase(name);
        final data = entry.value as JSONMap;
        final type = data["type"] as String;

        final field = BaseField.fromData(data, type, fieldName);
        if (field == null) {
          print("Unrecognized type $type");
          continue;
        }

        final supportingClasses = field.generateSupportingClasses();
        if (supportingClasses != null) lib.body.addAll(supportingClasses);

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
  }
}
