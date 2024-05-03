import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';

/// final _incompatibleNameRegex = RegExp('[^a-zA-Z]');
const incompatibleNameRegex = "[^a-zA-Z]";
final incompatibleNameRegexField = Field(
  (f) => f
    ..modifier = FieldModifier.final$
    ..name = "_incompatibleNameRegex"
    ..assignment = Code("RegExp('$incompatibleNameRegex')"),
);

/// Out? _mapIfNotNull<In, Out>(In?, Out? Function(In))
final mapIfNotNullMethod = Method(
  (m) => m
    ..returns = refer("Out?")
    ..name = "_mapIfNotNull"
    ..types = ListBuilder([refer("In"), refer("Out")])
    ..requiredParameters.addAll([
      Parameter((p) => p
        ..type = refer("In?")
        ..name = "value"),
      Parameter((p) => p
        ..type = refer("Out? Function(In)")
        ..name = "mapper"),
    ])
    ..body = Code("return value == null ? null : mapper(value);"),
);
