import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/utils.dart';

import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/http_client.dart';
import 'package:flutter_storyblok_code_generator/utils/code_builder.dart';
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
  late final TypeReference type = switch (source) {
    OptionSource.self => referType(enumName),
    OptionSource.internal_stories => referType(
        "$StoryIdentifierUUID",
        importUrl: 'package:flutter_storyblok/request_parameters.dart',
        nullable: !isRequired,
      ),
    OptionSource.internal_languages => referType("$String", nullable: !isRequired), // TODO Language enum
    OptionSource.internal => referType(sanitizeName(data["datasource_slug"], isClass: true)),
    OptionSource.external => referType(externalEnumName),
  };

  Spec _buildEnum(String name, Iterable<JSONMap> cases) {
    return buildEnum(
      name,
      cases.map((e) => MapEntry(e["name"], e["value"])),
    );
  }

  @override
  Future<Spec?> buildSupportingClass() async {
    return switch (source) {
      OptionSource.self => _buildEnum(enumName, List<JSONMap>.from(data["options"])),
      OptionSource.internal_stories => null,
      OptionSource.internal_languages => null,
      OptionSource.internal => null,
      OptionSource.external => await StoryblokHttpClient.getDatasourceFromExternalSource(
          Uri.parse(data["external_datasource"]),
        ).then(
          (options) => _buildEnum(externalEnumName, options),
        ),
    };
  }

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    return switch (source) {
      OptionSource.self => buildInstantiateEnum(enumName, valueExpression.code.toString()),
      OptionSource.internal_stories => type.invoke(valueExpression),
      OptionSource.internal_languages => valueExpression,
      OptionSource.internal => buildInstantiateEnum(data["datasource_slug"], valueExpression.code.toString()),
      OptionSource.external => buildInstantiateEnum(externalEnumName, valueExpression.code.toString()),
    };
  }
}

enum OptionSource {
  self, // data is from self.options parameter, needs to be generated
  internal_stories, // data is story uuid
  internal_languages, // data is language default = "default"
  internal, // data is from Datasource
  external, // data is from Datasource
}
