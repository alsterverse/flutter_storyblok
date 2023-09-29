import 'dart:convert';
import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_casing/dart_casing.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter_storyblok/asset.dart';
import 'package:flutter_storyblok/link_type.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/utils.dart';
import 'package:http/http.dart' as http;

final dartFormatter = DartFormatter(fixes: StyleFix.all, pageWidth: 120);
final dartEmitter = DartEmitter.scoped(orderDirectives: true, useNullSafetySyntax: true);

String spaceId = "";
String authorization = "";

void main(List<String> args) async {
  spaceId = args[0];
  authorization = args[1];
  final outputPath = args[2];

  final lib = LibraryBuilder();
  lib.directives.addAll([
    Directive.import('package:flutter_storyblok/asset.dart'),
    Directive.import('package:flutter_storyblok/link_type.dart'),
  ]);

  await downloadDatasource();
  lib.body.addAll(datasourceData.values);

  // final componentJson = jsonDecode(File("tools/component.json").readAsStringSync()) as JSONMap;
  final components = await downloadComponents(lib);

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

  final file = File(outputPath);
  if (file.existsSync()) file.deleteSync();
  file.writeAsStringSync(output);
}

//MARK: - Datasource

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

// TODO Dimensions
Future downloadDatasource() async {
  final ds = await apiGet("datasources");
  final datasources = List<JSONMap>.from(ds["datasources"]).map(Datasource.fromJson).toList();
  final allEntries = await Future.wait(datasources.map((e) async {
    final d = await apiGet("datasource_entries", {"datasource_id": e.id.toString()});
    return List<JSONMap>.from(d["datasource_entries"]).map(DatasourceEntry.fromJson).toList();
  }));
  final mapped = datasources.mapIndexed((i, e) => (e, allEntries[i])).toList();

  for (final (d, entries) in mapped) {
    final name = d.slug;
    datasourceData[name] = buildEnum(name, entries.map((e) => e.value));
  }
}

//MARK: - Components

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

Future<List<({Component component, ClassBuilder builder})>> downloadComponents(LibraryBuilder lib) async {
  final d = await apiGet("components");
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
      final _BaseField? baseField = switch (type) {
        "bloks" => _Bloks.fromJson(data, name),
        "text" => _Text.fromJson(data, fieldName),
        "textarea" => _TextArea.fromJson(data, fieldName),
        "markdown" => _Markdown.fromJson(data, fieldName),
        "number" => _Number.fromJson(data, fieldName),
        "boolean" => _Boolean.fromJson(data, fieldName),
        "datetime" => _DateTime.fromJson(data, fieldName),
        "asset" => _Asset.fromJson(data, fieldName),
        // "multiasset" => _MultiAsset.fromJson(data, fieldName),
        "multilink" => _Link.fromJson(data, fieldName),
        "option" => _Option.fromJson(data, fieldName),
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
        f.modifier = FieldModifier.final$;
        baseField.buildField(f);
      }));

      co.initializers.add(Code(
        "$fieldName = ${baseField.generateInitializerCode('json["$name"]')}",
      ));
    }

    c.constructors.add(co.build());
    return (component: component, builder: c);
  }).toList();
}

//MARK: - REST

Future<JSONMap> apiGet(String path, [JSONMap? params]) async {
  final resp = await http.get(
    Uri.https("mapi.storyblok.com", "/v1/spaces/$spaceId/$path", params),
    headers: {"Authorization": authorization},
  );
  final json = jsonDecode(resp.body) as JSONMap;
  return json;
}

//MARK: - Base fields

abstract class _BaseField {
  final JSONMap data;
  final String name;
  final bool isRequired;
  final int? position;
  _BaseField(this.data, this.name, this.isRequired, this.position);
  _BaseField.fromJson(this.data, this.name)
      : isRequired = tryCast<bool>(data["required"]) ?? false,
        position = tryCast<int>(data["pos"]);

  String symbol();

  void buildFieldType(TypeReferenceBuilder t) => t
    ..symbol = symbol()
    ..isNullable = !isRequired;

  void buildField(FieldBuilder f) {
    f.name = name;
    f.type = TypeReference(buildFieldType);
  }

  List<Spec>? generateSupportingClasses() => null;

  String generateInitializerCode(String valueCode) => valueCode;
}

final class _Bloks extends _BaseField {
  final int? maximum;
  final bool restrictTypes;
  final List<String> restrictedTypes;
  _Bloks.fromJson(super.data, super.name)
      : maximum = data["maximum"],
        restrictTypes = data["restrict_components"] ?? false,
        restrictedTypes = List.from(data["component_whitelist"] ?? []),
        super.fromJson();

  String _type() {
    if (restrictTypes && restrictedTypes.length == 1) {
      return Casing.pascalCase(restrictedTypes.first);
    } else {
      return "Blok";
    }
  }

  @override
  String symbol() => maximum == 1 ? _type() : "List<${_type()}>";

  @override
  String generateInitializerCode(String valueCode) {
    final code = "${List<JSONMap>}.from($valueCode).map(${_type()}.fromJson).toList()"; // TODO Nullable
    return maximum == 1 ? "$code.first" : code;
  }
}

final class _Text extends _BaseField {
  _Text.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$String";
}

final class _TextArea extends _Text {
  _TextArea.fromJson(super.data, super.name) : super.fromJson();
}

final class _Markdown extends _Text {
  _Markdown.fromJson(super.data, super.name) : super.fromJson();
}

final class _Number extends _BaseField {
  final int? decimals;
  _Number.fromJson(super.data, super.name)
      : decimals = tryCast<int>(data["decimals"]),
        super.fromJson();

  @override
  String symbol() => decimals == 0 ? "$int" : "$double";

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}.${isRequired ? "parse" : "tryParse"}($valueCode)";
  }
}

final class _Boolean extends _BaseField {
  _Boolean.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$bool";

  @override
  void buildFieldType(TypeReferenceBuilder t) {
    super.buildFieldType(t);
    t.isNullable = false;
  }

  @override
  String generateInitializerCode(String valueCode) => "$valueCode${isRequired ? "" : " ?? false"}";
}

// String is the raw value type
final class _DateTime extends _BaseField {
  _DateTime.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$DateTime";

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}.${isRequired ? "parse" : "tryParse"}($valueCode)";
  }
}

final class _Asset extends _BaseField {
  _Asset.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$Asset";

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}.fromJson($JSONMap.from($valueCode))";
  }
}

// TODO
// final class _MultiAsset extends _BaseField {
//   _MultiAsset.fromJson(super.data, super.name) : super.fromJson();

//   @override
//   String symbol() => "${List<SBAsset>}";
// }

final class _Link extends _BaseField {
  final bool isAssetAllowed;
  final bool isEmailAllowed;
  // final bool restrictContentType;
  // final List<String> restrictedTypes;
  _Link.fromJson(super.data, super.name)
      : isAssetAllowed = data["asset_link_type"] ?? false,
        isEmailAllowed = data["email_link_type"] ?? false,
        // restrictContentType = data["restrict_content_types"] ?? false,
        // restrictedTypes = List.from(data["component_whitelist"] ?? []),
        super.fromJson();

  @override
  String symbol() {
    if (isAssetAllowed && isEmailAllowed) return "$LinkType";
    if (isAssetAllowed) return "$BaseWithAssetLinkTypes";
    if (isEmailAllowed) return "$BaseWithEmailLinkTypes";
    return "$BaseLinkTypes";
  }

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}.fromJson($JSONMap.from($valueCode))";
  }
}

// TODO Refactor complexity
// Single value
final class _Option extends _BaseField {
  final _OptionSource source;
  final String enumName;
  _Option.fromJson(super.data, super.name)
      : source = _OptionSource.values.byName(tryCast<String>(data["source"]) ?? _OptionSource.self.name),
        enumName = "${name}_Option",
        super.fromJson();

  @override
  String symbol() => switch (source) {
        _OptionSource.self => Casing.pascalCase(enumName),
        _OptionSource.internal_stories => "$StoryIdentifierUUID",
        _OptionSource.internal_languages => "$String", // TODO Language enum
        _OptionSource.internal => datasourceData[data["datasource_slug"]]!.name,
      };

  @override
  List<Spec>? generateSupportingClasses() {
    final e = switch (source) {
      _OptionSource.self => buildEnum(enumName, List<JSONMap>.from(data["options"]).map((e) => e["value"])),
      _OptionSource.internal_stories => null,
      _OptionSource.internal_languages => null,
      _OptionSource.internal => null
    };
    if (e != null) return [e];
    return null;
  }

  @override
  String generateInitializerCode(String valueCode) {
    return super.generateInitializerCode(switch (source) {
      _OptionSource.self =>
        "${Casing.pascalCase(enumName)}.values.asNameMap()[$valueCode] ?? ${Casing.pascalCase(enumName)}.unknown",
      _OptionSource.internal_stories => "StoryIdentifierUUID($valueCode)",
      _OptionSource.internal_languages => valueCode,
      _OptionSource.internal =>
        "${datasourceData[data["datasource_slug"]]!.name}.values.asNameMap()[$valueCode] ?? ${datasourceData[data["datasource_slug"]]!.name}.unknown",
    });
  }
}

enum _OptionSource {
  self, // data is from self.options parameter, needs to be generated
  internal_stories, // data is story uuid
  internal_languages, // data is language default = "default" TODO
  internal, // data is from Datasource
}

// TODO Paused because complex
// Multi value
// final class _Options extends _Option {
//   _Options.fromJson(super.data, super.name) : super.fromJson();

//   @override
//   String symbol() => "List<${super.symbol()}>"; // Must be raw string

//   @override
//   String generateInitializerCode(String valueCode) {
//     return "$valueCode.map((e) => enumName.values.byName(e)).toList()";
//   }
// }

Enum buildEnum(String name, Iterable<String> cases) {
  cases = [...cases, "unknown"];
  return Enum((e) => e
    ..name = Casing.pascalCase(name)
    ..values.addAll(
      cases.map((c) => EnumValue((v) => v..name = Casing.camelCase(c))),
    ));
}
