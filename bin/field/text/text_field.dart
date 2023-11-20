import 'base_text_field.dart';

final class TextField extends BaseTextField {
  TextField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$String";
}
