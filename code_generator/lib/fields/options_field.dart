import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok_code_generator/fields/option_field.dart';
import 'package:flutter_storyblok_code_generator/utils/enum.dart';

final class OptionsField extends OptionField {
  OptionsField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() {
    final symbol = super.symbol().replaceAll("?", "");
    return "List<$symbol>";
  }

  @override
  void buildFieldType(TypeReferenceBuilder t) {
    super.buildFieldType(t);
    t.isNullable = false;
  }

  @override
  String generateInitializerCode(String valueCode) {
    final list = "${List<String>}.from($valueCode ?? [])";
    return switch (source) {
      OptionSource.self => "$list.map(${buildInstantiateEnum(enumName)}).toList()",
      OptionSource.internal_stories => "$list.map($StoryIdentifierUUID.new).toList()",
      OptionSource.internal_languages => list,
      OptionSource.internal => "$list.map(${buildInstantiateEnum(data["datasource_slug"])}).toList()",
      OptionSource.external => "$list.map(${buildInstantiateEnum(externalEnumName)}).toList()",
    };
  }
}
