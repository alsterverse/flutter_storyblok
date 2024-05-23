import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';
import '../utils/build_enum.dart';
import '../utils/sanitize_name.dart';
import '../utils/utils.dart';

base class OptionField extends BaseField {
  final OptionSource source;
  final String enumName;

  OptionField.fromJson(super.data, String name, String ownerName)
      : source = OptionSource.values.byName(data["source"] ?? OptionSource.self.name),
        enumName = sanitizeName("${unsanitizedName("${ownerName}_$name")}_Option", isClass: true),
        super.fromJson();

  @override
  late final TypeReference type = switch (source) {
    OptionSource.self => referType(enumName),
    OptionSource.internal_stories => referType(
        "$StoryIdentifierUUID",
        importUrl: 'package:flutter_storyblok/flutter_storyblok.dart',
        nullable: !isRequired,
      ),
    OptionSource.internal_languages => referType("$String", nullable: !isRequired), // TODO Language enum
    OptionSource.internal => referType(sanitizeName(data["datasource_slug"], isClass: true)),
    OptionSource.external => referType(enumName),
  };

  @override
  late final bool shouldSkip = switch (source) {
    OptionSource.self => tryCast<List>(data["options"])?.isEmpty ?? true,
    OptionSource.internal_stories => false,
    OptionSource.internal_languages => false,
    OptionSource.internal => tryCast<String>(data["datasource_slug"])?.isEmpty ?? true,
    OptionSource.external =>
      mapIfNotNull(tryCast<String>(data["external_datasource"]), (v) => v.isEmpty || Uri.tryParse(v) == null) ?? true,
  };

  @override
  Future<List<Spec>?> buildSupportingClass(Future<List<JSONMap>> Function(Uri) getExternalSource) async {
    final spec = switch (source) {
      OptionSource.self => _buildEnum(enumName, List<JSONMap>.from(data["options"])),
      OptionSource.internal_stories => null,
      OptionSource.internal_languages => null,
      OptionSource.internal => null,
      OptionSource.external => _buildEnum(
          enumName,
          (await getExternalSource(Uri.parse(data["external_datasource"]))).toList(),
        ),
    };
    return spec == null ? null : [spec];
  }

  Spec _buildEnum(String name, Iterable<JSONMap> cases) {
    return buildEnum(
      name,
      cases.map((e) => MapEntry(e["name"], e["value"])),
    );
  }

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    return switch (source) {
      OptionSource.self => buildInstantiateEnum(enumName, valueExpression.code.toString()),
      OptionSource.internal_stories =>
        initializerFromRequired(isRequired, valueExpression, type.invoke(valueExpression)),
      OptionSource.internal_languages => valueExpression,
      OptionSource.internal => buildInstantiateEnum(data["datasource_slug"], valueExpression.code.toString()),
      OptionSource.external => buildInstantiateEnum(enumName, valueExpression.code.toString()),
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
