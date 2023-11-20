import 'base_field.dart';

final class DateTimeField extends BaseField {
  DateTimeField.fromJson(super.data, super.name) : super.fromJson();

  @override
  String symbol() => "$DateTimeField";

  @override
  String generateInitializerCode(String valueCode) {
    return "${symbol()}.${isRequired ? "parse" : "tryParse"}($valueCode)";
  }
}
