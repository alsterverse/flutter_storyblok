import 'package:code_builder/code_builder.dart';

import 'base_field.dart';
import '../utils/code_builder_extensions.dart';

base class TextField extends BaseField {
  TextField.fromJson(super.data) : super.fromJson();

  @override
  late final TypeReference type = referType(
    "$String",
    nullable: !isRequired,
  );
}
