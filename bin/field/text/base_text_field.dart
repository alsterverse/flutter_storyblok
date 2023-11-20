import '../base_field.dart';

abstract class BaseTextField extends BaseField {
  BaseTextField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$String";
}
