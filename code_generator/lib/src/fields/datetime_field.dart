import 'package:code_builder/code_builder.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

final class DateTimeField extends BaseField {
  DateTimeField.fromJson(super.data) : super.fromJson();

  @override
  TypeReference get type => referType(
        "$DateTime",
        nullable: !isRequired,
      );

  @override
  Expression buildInitializer(CodeExpression valueExpression) =>
      type.invokeNamed(isRequired ? "parse" : "tryParse", valueExpression);
}
