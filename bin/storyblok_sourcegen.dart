import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_casing/dart_casing.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter_storyblok/asset.dart';
import 'package:flutter_storyblok/utils.dart';

import 'api.dart';
import 'field/asset_field.dart';
import 'field/base_field.dart';
import 'field/blok_fields.dart';
import 'field/boolean_field.dart';
import 'field/datetime_field.dart';
import 'field/link_field.dart';
import 'field/multi_asset_field.dart';
import 'field/number_field.dart';
import 'field/option_field.dart';
import 'field/text/text_area_field.dart';
import 'field/text/text_field.dart';
import 'field/text/text_markdown_field.dart';
import 'util/enum.dart';

final dartFormatter = DartFormatter(fixes: StyleFix.all, pageWidth: 120);
final dartEmitter = DartEmitter.scoped(orderDirectives: true, useNullSafetySyntax: true);

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
    lib.directives.addAll([
      Directive.import('package:flutter_storyblok/asset.dart'),
      Directive.import('package:flutter_storyblok/link_type.dart'),
    ]);

    await _downloadDatasource();
    lib.body.addAll(datasourceData.values);

    final components = await _downloadComponents(lib);

    final blokClazz = Class((c) {
      c.sealed = true;
      c.name = "Blok";
      c.constructors.addAll([
        Constructor(),
        Constructor((co) => co
          ..factory = true
          ..name = "fromJson"
          ..requiredParameters.add(
            Parameter((p) => p
              ..name = "json"
              ..type = refer("$JSONMap")),
          )
          ..body = Code([
            'switch (json["component"] as String) {',
            ...components.map((e) => 'case "${e.component.name}": return ${e.builder.name}.fromJson(json);'),
            'default: print("Unrecognized type \$\{json["component"]\}"); return UnrecognizedBlok();',
            '}',
          ].join("\n"))),
      ]);
    });
    lib.body.add(blokClazz);

    lib.body.addAll([
      ...components.map((e) => e.builder),
      ClassBuilder()..name = "UnrecognizedBlok",
    ].map((c) {
      c.modifier = ClassModifier.final$;
      c.extend = refer(blokClazz.name);
      return c.build();
    }));

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

  Future<List<({Component component, ClassBuilder builder})>> _downloadComponents(LibraryBuilder lib) async {
    final d = await _apiClient.get("components");
    final components = [
      ...List<JSONMap>.from(d["components"]).map(Component.fromJson),
    ];
    return components.map((component) {
      final c = ClassBuilder();
      c.name = Casing.pascalCase(component.name);
      final schema = component.schema;

      final co = ConstructorBuilder();
      co.name = "fromJson";
      co.requiredParameters.add(Parameter((p) => p
        ..type = refer("$JSONMap")
        ..name = "json"));

      for (final entry in schema.entries) {
        final name = entry.key;
        final data = entry.value as JSONMap;
        final type = data["type"] as String;
        // print("final ${data["type"]} $name");

        final fieldName = Casing.camelCase(name);
        final BaseField? baseField = switch (type) {
          "bloks" => BlokFields.fromJson(data, name),
          "text" => TextField.fromJson(data, fieldName),
          "textarea" => TextAreaField.fromJson(data, fieldName),
          "markdown" => MarkdownField.fromJson(data, fieldName),
          "number" => NumberField.fromJson(data, fieldName),
          "boolean" => BooleanField.fromJson(data, fieldName),
          "datetime" => DateTimeField.fromJson(data, fieldName),
          "asset" => AssetField.fromJson(data, fieldName),
          "multiasset" => MultiAssetField.fromJson(data, name),
          "multilink" => LinkField.fromJson(data, fieldName),
          "option" => OptionField.fromJson(data, fieldName),
          // "options" => _Options.fromJson(data, fieldName),
          _ => null,
        };
        if (baseField == null) {
          print("Unrecognized type $type");
          continue;
        }

        final supportingClasses = baseField.generateSupportingClasses();
        if (supportingClasses != null) lib.body.addAll(supportingClasses);

        c.fields.add(Field((f) {
          f.type = TypeReference(baseField.buildFieldType);
          f.modifier = FieldModifier.final$;
          f.name = fieldName;
        }));

        co.initializers.add(Code(
          "$fieldName = ${baseField.generateInitializerCode('json["$name"]')}",
        ));
      }

      c.constructors.add(co.build());
      return (component: component, builder: c);
    }).toList();
  }
}

// Key is the datasource slug
Map<String, Enum> datasourceData = {};

class Datasource {
  final int id;
  final String slug;
  // final dynamic dimensions;
  Datasource.fromJson(JSONMap json)
      : id = json["id"],
        slug = json["slug"];
}

class DatasourceEntry {
  final int id;
  final String value;
  // final dynamic dimensions;
  DatasourceEntry.fromJson(JSONMap json)
      : id = json["id"],
        value = json["value"];
}

class Component {
  final String name;
  final JSONMap schema;
  final bool isRoot;
  final bool isNestable;
  Component.fromJson(JSONMap json)
      : name = json["name"],
        isRoot = json["is_root"],
        isNestable = json["is_nestable"],
        schema = JSONMap.from(json["schema"]);
}
