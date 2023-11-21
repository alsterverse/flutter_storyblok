import 'package:code_builder/code_builder.dart';
import 'package:dart_casing/dart_casing.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/utils.dart';

import '../storyblok_sourcegen.dart';
import '../util/enum.dart';
import 'base_field.dart';

final class OptionField extends BaseField {
  final OptionSource source;
  final String enumName;
  OptionField.fromJson(super.data, super.name)
      : source = OptionSource.values.byName(tryCast<String>(data["source"]) ?? OptionSource.self.name),
        enumName = "${name}_Option",
        super.fromJson();

  @override
  String symbol() => switch (source) {
        OptionSource.self => Casing.pascalCase(enumName),
        OptionSource.internal_stories => "$StoryIdentifierUUID",
        OptionSource.internal_languages => "$String", // TODO Language enum
        OptionSource.internal => datasourceData[data["datasource_slug"]]!.name,
      };

  @override
  List<Spec>? generateSupportingClasses() {
    final e = switch (source) {
      OptionSource.self => buildEnum(enumName, List<JSONMap>.from(data["options"]).map((e) => e["value"])),
      OptionSource.internal_stories => null,
      OptionSource.internal_languages => null,
      OptionSource.internal => null
    };
    if (e != null) return [e];
    return null;
  }

  @override
  String generateInitializerCode(String valueCode) {
    return super.generateInitializerCode(switch (source) {
      OptionSource.self =>
        "${Casing.pascalCase(enumName)}.values.asNameMap()[$valueCode] ?? ${Casing.pascalCase(enumName)}.unknown",
      OptionSource.internal_stories => "StoryIdentifierUUID($valueCode)",
      OptionSource.internal_languages => valueCode,
      OptionSource.internal =>
        "${datasourceData[data["datasource_slug"]]!.name}.values.asNameMap()[$valueCode] ?? ${datasourceData[data["datasource_slug"]]!.name}.unknown",
    });
  }
}

enum OptionSource {
  self, // data is from self.options parameter, needs to be generated
  internal_stories, // data is story uuid
  internal_languages, // data is language default = "default" TODO
  internal, // data is from Datasource
}
