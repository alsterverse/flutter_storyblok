import 'package:code_builder/code_builder.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

final class NumberField extends BaseField {
  final int? decimals;
  NumberField.fromJson(super.data)
      : decimals = data["decimals"],
        super.fromJson();

  @override
  late final TypeReference type = referType(
    decimals == 0 ? "$int" : "$double",
    nullable: !isRequired,
  );

  @override
  Expression buildInitializer(CodeExpression valueExpression) =>
      type.nonNullable.invokeNamed(isRequired ? "parse" : "tryParse", valueExpression);
}
