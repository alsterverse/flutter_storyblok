import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/utils.dart';

import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/http_client.dart';
import 'package:flutter_storyblok_code_generator/utils/enum.dart';
import 'package:flutter_storyblok_code_generator/utils/names.dart';

class OptionField extends BaseField {
  final OptionSource source;
  final String enumName;
  final String externalEnumName;

  OptionField.fromJson(super.data, super.name)
      : source = OptionSource.values.byName(tryCast<String>(data["source"]) ?? OptionSource.self.name),
        enumName = sanitizeName("${unsanitizedName(name)}_Option", isClass: true),
        externalEnumName = sanitizeName("${unsanitizedName(name)}_ExternalOption", isClass: true),
        super.fromJson();

  @override
  String symbol() => switch (source) {
        OptionSource.self => enumName,
        OptionSource.internal_stories => "$StoryIdentifierUUID",
        OptionSource.internal_languages => "$String?", // TODO Language enum
        OptionSource.internal => cachedSanitizedName(data["datasource_slug"], isClass: true),
        OptionSource.external => externalEnumName,
      };

  Spec _buildEnum(String name, Iterable<JSONMap> cases) {
    return buildEnum(
      name,
      cases.map((e) => MapEntry(e["name"], e["value"])),
    );
  }

  @override
  Future<Spec?> generateSupportingClass() async {
    return switch (source) {
      OptionSource.self => _buildEnum(enumName, List<JSONMap>.from(data["options"])),
      OptionSource.internal_stories => null,
      OptionSource.internal_languages => null,
      OptionSource.internal => null,
      OptionSource.external => await StoryblokHttpClient.getDatasourceFromExternalSource(
          Uri.parse(data["external_datasource"]),
        ).then((options) => _buildEnum(externalEnumName, options)),
    };
  }

  @override
  String generateInitializerCode(String valueCode) {
    return super.generateInitializerCode(switch (source) {
      OptionSource.self => buildInstantiateEnum(enumName, valueCode),
      OptionSource.internal_stories => "$StoryIdentifierUUID($valueCode)",
      OptionSource.internal_languages => valueCode,
      OptionSource.internal => buildInstantiateEnum(data["datasource_slug"], valueCode),
      OptionSource.external => buildInstantiateEnum(externalEnumName, valueCode),
    });
  }
}

enum OptionSource {
  self, // data is from self.options parameter, needs to be generated
  internal_stories, // data is story uuid
  internal_languages, // data is language default = "default"
  internal, // data is from Datasource
  external, // data is from Datasource
}