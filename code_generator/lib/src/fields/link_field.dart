import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok_code_generator/src/utils/sanitize_name.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

final class LinkField extends BaseField {
  final bool isAssetAllowed;
  final bool isEmailAllowed;
  final bool restrictContentType;
  final List<String> restrictedTypes;
  LinkField.fromJson(super.data)
      : isAssetAllowed = data["asset_link_type"] ?? false,
        isEmailAllowed = data["email_link_type"] ?? false,
        restrictContentType = data["restrict_content_types"] ?? false,
        restrictedTypes = List.from(data["component_whitelist"] ?? []),
        super.fromJson();

  @override
  late final TypeReference type = () {
    final storyType = restrictContentType && restrictedTypes.length == 1
        ? sanitizeName(restrictedTypes.first, isClass: true)
        : "Blok";
    return referType(
      switch ((isAssetAllowed, isEmailAllowed)) {
        (true, true) => "Link<$storyType>",
        (true, _) => "DefaultWithAssetLink<$storyType>",
        (_, true) => "DefaultWithEmailLink<$storyType>",
        _ => "DefaultLink<$storyType>",
      },
      importUrl: 'package:flutter_storyblok/fields.dart',
      nullable: !isRequired,
    );
  }();

  @override
  Expression buildInitializer(CodeExpression valueExpression) {
    final expression = type.invokeNamed("fromJson", valueExpression);
    if (isRequired) return expression;
    return valueExpression.isNotA(refer("$Map")).conditional(literalNull, expression);
  }
}
