import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok_code_generator/src/code_emitter.dart';
import 'package:flutter_storyblok_code_generator/src/models/component.dart';
import 'package:flutter_storyblok_code_generator/src/utils/build_sealed_class.dart';

import 'fields/base_field.dart';
import 'http_client.dart';
import 'utils/build_enum.dart';
import 'utils/sanitize_name.dart';
import 'utils/code_builder_extensions.dart';
import 'utils/utils.dart';

class StoryblokCodegen {
  StoryblokCodegen({
    required this.components,
    required List<DatasourceWithEntries> datasourceWithEntries,
    required this.getExternalDatasourceEntries,
  }) : internalDatasources = datasourceWithEntries.map((e) {
          final (:datasource, :entries) = e;
          return buildEnum(datasource.slug, entries.map((e) => MapEntry(e.name, e.value)));
        }).toList();

  final List<Component> components;
  final List<Enum> internalDatasources;
  final Future<List<JSONMap>> Function(Uri) getExternalDatasourceEntries;
  final codeEmitter = CodeEmitter();

  final Set<Uri> _externalDatasourceUrls = {};

  Future<String> generate() async {
    final lib = LibraryBuilder();
    lib.name = "bloks";
    lib.generatedByComment = "flutter_storyblok_code_generator";
    lib.ignoreForFile.add("unused_import");

    final components = _buildComponents(lib).toList();

    // enum <name> {
    lib.body.addAll(internalDatasources);

    lib.body.addAll(await Future.wait(
      _externalDatasourceUrls.map((e) => buildEnumFromExternalSource(e, getExternalDatasourceEntries)),
    ));

    // sealed class Blok {
    final (:sealedClass, :classes) = buildBloksSealedClass(
      name: "Blok",
      classes: components
          .map((e) => (
                key: e.key,
                builder: e.builder,
                initializer: (Expression expression) => expression.code,
              ))
          .toList(),
      throwUnrecognized: false,
    );
    lib.body.add((sealedClass //
          ..docs.add("/// This is the base class for all blocks defined in `Block Library`"))
        .build());
    lib.body.addAll(classes);

    final library = lib.build();
    return codeEmitter.codeFromSpec(library);
  }

  List<({String key, ClassBuilder builder})> _buildComponents(LibraryBuilder lib) {
    return components.map((component) {
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

        final supportingClass = field.buildSupportingClass();
        if (supportingClass != null) lib.body.addAll(supportingClass);

        final externalDatasourceUrl = field.getExternalDatasourceUrl();
        if (externalDatasourceUrl != null) _externalDatasourceUrls.add(externalDatasourceUrl);

        c.fields.add(field.build(fieldName));

        con.initializers.add(
          fieldName.expression.assign(field.buildInitializer("json[${literal(name)}]".expression)).code,
        );
      }
      c.constructors.add(con.build());
      return (key: component.name, builder: c);
    }).toList();
  }
}
