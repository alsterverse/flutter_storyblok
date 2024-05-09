import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok/utils.dart';

extension CodeBuilderStringExtensions on String {
  CodeExpression get expression => CodeExpression(code);

  Code get code => Code(this);

  Reference reference([String? url]) => refer(this, url);
}

extension CodeExtensions on Code {
  CodeExpression get expression => CodeExpression(this);
}

extension ExpressionExtensions on Expression {
  Expression invokeNamed(String name, [Expression? argument]) => property(name).call([if (argument != null) argument]);
  Expression invoke([Expression? argument]) => call([if (argument != null) argument]);
}

extension TypeReferenceExtensions on TypeReference {
  TypeReference get nonNullable => rebuild((t) => t.isNullable = false);
}

TypeReference referType(
  String symbol, {
  bool? nullable,
  String? importUrl,
  List<TypeReference>? genericTypes,
}) =>
    TypeReference((t) {
      t.symbol = symbol;
      t.url = importUrl;
      t.isNullable = nullable;
      if (genericTypes != null) {
        t.types.addAll(genericTypes);
      }
    }
        //
        );

TypeReference referList({
  TypeReference? type,
  bool? nullable,
}) =>
    referType(
      "List",
      nullable: nullable,
      genericTypes: type == null ? null : [type],
    );

Expression literalEmptyList() => literalConstList([]);

TypeReference referJSONMap({
  bool? nullable,
}) =>
    referType("$JSONMap", nullable: nullable);
