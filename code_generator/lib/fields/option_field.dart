import 'package:code_builder/code_builder.dart';
import 'package:dart_casing/dart_casing.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/utils.dart';

import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/utils/enum.dart';

final class OptionField extends BaseField {
  final OptionSource source;
  final String enumName;
  OptionField.fromJson(super.data, super.name)
      : source = OptionSource.values.byName(tryCast<String>(data["source"]) ?? OptionSource.self.name),
        enumName = Casing.pascalCase("${name}_Option"),
        super.fromJson();

  @override
  String symbol() => switch (source) {
        OptionSource.self => enumName,
        OptionSource.internal_stories => "$StoryIdentifierUUID",
        OptionSource.internal_languages => "$String", // TODO Language enum
        OptionSource.internal => Casing.pascalCase(data["datasource_slug"]),
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
      OptionSource.self => buildInstantiateEnum(enumName, valueCode),
      OptionSource.internal_stories => "$StoryIdentifierUUID($valueCode)",
      OptionSource.internal_languages => valueCode,
      OptionSource.internal => buildInstantiateEnum(Casing.pascalCase(data["datasource_slug"]), valueCode),
    });
  }
}

enum OptionSource {
  self, // data is from self.options parameter, needs to be generated
  internal_stories, // data is story uuid
  internal_languages, // data is language default = "default" TODO
  internal, // data is from Datasource
}
