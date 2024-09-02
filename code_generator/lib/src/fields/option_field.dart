import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/models.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';
import '../utils/build_enum.dart';
import '../utils/sanitize_name.dart';
import '../utils/utils.dart';

base class OptionField extends BaseField {
  final OptionSource source;
  final String enumName;

  /// If source is external, this must not be null
  final Uri? externalSourceUrl;

  OptionField.fromJson(super.data, String name, String ownerName)
      : source = OptionSource.values.byName(data["source"] ?? OptionSource.self.name),
        enumName = sanitizeName("${unsanitizedName("${ownerName}_$name")}_Option", isClass: true),
        externalSourceUrl = mapIfNotNull(tryCast<String>(data["external_datasource"]), Uri.parse),
        super.fromJson();

  @override
  late final bool shouldSkip = switch (source) {
    OptionSource.self => tryCast<List>(data["options"])?.isEmpty ?? true,
    OptionSource.internal_stories => false,
    OptionSource.internal_languages => false,
    OptionSource.internal => tryCast<String>(data["datasource_slug"])?.isEmpty ?? true,
    OptionSource.external => externalSourceUrl == null,
  };

  @override
  late final TypeReference type = switch (source) {
    OptionSource.self => referType(enumName),
    OptionSource.internal_stories => referType(
        "$StoryIdentifierUUID",
        importUrl: 'package:flutter_storyblok/models.dart',
        nullable: !isRequired,
      ),
    OptionSource.internal_languages => referType("$String", nullable: !isRequired), // TODO Language enum
    OptionSource.internal => referType(sanitizeName(data["datasource_slug"], isClass: true)),
    OptionSource.external => referType(sanitizeName(externalSourceClassName(externalSourceUrl!), isClass: true)),
  };

  @override
  List<Spec>? buildSupportingClass() {
    return switch (source) {
      OptionSource.self => [
          buildEnum(enumName, List.from(data["options"]).map((e) => MapEntry(e["name"], e["value"])))
        ],
      OptionSource.internal_stories => null,
      OptionSource.internal_languages => null,
      OptionSource.internal => null,
      OptionSource.external => null
    };
  }

  @override
  Uri? getExternalDatasourceUrl() => externalSourceUrl;

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    final type = this.type.nonNullable;
    return switch (source) {
      OptionSource.self => buildInstantiateEnum(type.symbol, valueExpression.code.toString()),
      OptionSource.internal_stories =>
        initializerFromRequired(isRequired, valueExpression, type.invoke(valueExpression)),
      OptionSource.internal_languages => valueExpression,
      OptionSource.internal => buildInstantiateEnum(type.symbol, valueExpression.code.toString()),
      OptionSource.external => buildInstantiateEnum(type.symbol, valueExpression.code.toString()),
    };
  }
}

enum OptionSource {
  self, // data is from self.options parameter, needs to be generated
  // ignore: constant_identifier_names
  internal_stories, // data is story uuid
  // ignore: constant_identifier_names
  internal_languages, // data is language default = "default"
  internal, // data is from Datasource
  external, // data is from Datasource
}
