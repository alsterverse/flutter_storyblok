import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/utils.dart';

import 'package:flutter_storyblok_code_generator/fields/base_field.dart';
import 'package:flutter_storyblok_code_generator/utils/code_builder.dart';

final class NumberField extends BaseField {
  final int? decimals;
  NumberField.fromJson(super.data, super.name)
      : decimals = tryCast<int>(data["decimals"]),
        super.fromJson();

  @override
  late final TypeReference type = referType(
    decimals == 0 ? "$int" : "$double",
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) =>
      type.invokeNamed(isRequired ? "parse" : "tryParse", valueExpression);
}
