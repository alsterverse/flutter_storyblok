import 'package:code_builder/code_builder.dart';

import 'option_field.dart';
import '../utils/code_builder_extensions.dart';
import '../enum.dart';

final class OptionsField extends OptionField {
  OptionsField.fromJson(super.data, super.name, super.ownerName) : super.fromJson();

  late final _type = super.type.nonNullable;

  @override
  TypeReference get type => referList(type: _type);

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    final expression = referList(type: referType("$String")).invokeNamed(
      "from",
      valueExpression.ifNullThen(literalEmptyList()),
    );

    return switch (source) {
      OptionSource.self => expression //
          .invokeNamed("map", buildInstantiateEnum(enumName))
          .invokeNamed("toList"),
      OptionSource.internal_stories => expression //
          .invokeNamed("map", _type.property("new"))
          .invokeNamed("toList"),
      OptionSource.internal_languages => expression,
      OptionSource.internal => expression //
          .invokeNamed("map", buildInstantiateEnum(data["datasource_slug"]))
          .invokeNamed("toList"),
      OptionSource.external => expression //
          .invokeNamed("map", buildInstantiateEnum(externalEnumName))
          .invokeNamed("toList"),
    };
  }
}
