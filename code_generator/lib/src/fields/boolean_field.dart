import 'package:code_builder/code_builder.dart';

import 'base_field.dart';
import '../utils/code_builder.dart';

final class BooleanField extends BaseField {
  BooleanField.fromJson(super.data, super.name) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$bool",
    nullable: false,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) => isRequired //
      ? valueExpression
      : valueExpression.ifNullThen(literalFalse);
}
