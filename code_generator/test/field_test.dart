import 'package:flutter_storyblok_code_generator/src/code_emitter.dart';
import 'package:flutter_storyblok_code_generator/src/fields/blok_fields.dart';
import 'package:flutter_storyblok_code_generator/src/fields/boolean_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/datetime_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/number_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/text_area_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/text_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/text_markdown_field.dart';
import 'package:flutter_storyblok_code_generator/src/utils/code_builder_extensions.dart';
import 'package:test/test.dart';

void main() {
  final emitter = CodeEmitter(scoped: false);
  final valueExpression = "json['data']";

  // MARK: - Blok
  group("Test Bloks field", () {
    test("Test default blok", () {
      final field = BlokField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final List<Blok> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Blok.fromJson).toList()"),
      );
    });
    test("Test required blok", () {
      final field = BlokField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final List<Blok> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Blok.fromJson).toList()"),
      );
    });
    test("Test restricted blok", () {
      final field = BlokField.fromJson({
        "restrict_components": true,
        "component_whitelist": ["foo"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final List<Foo> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Foo.fromJson).toList()"),
      );
    });
    test("Test multi-restricted blok", () {
      final field = BlokField.fromJson({
        "restrict_components": true,
        "component_whitelist": ["foo", "bar"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final List<Blok> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Blok.fromJson).toList()"),
      );
    });
    test("Test single restricted blok", () {
      final field = BlokField.fromJson({
        "maximum": 1,
        "restrict_components": true,
        "component_whitelist": ["foo"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final Foo? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
            "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Foo.fromJson).toList().firstOrNull"),
      );
    });
    test("Test required single restricted blok", () {
      final field = BlokField.fromJson({
        "required": true,
        "maximum": 1,
        "restrict_components": true,
        "component_whitelist": ["foo"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final Foo foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
            "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Foo.fromJson).toList().first"),
      );
    });
    test("Test single multi-restricted blok", () {
      final field = BlokField.fromJson({
        "maximum": 1,
        "restrict_components": true,
        "component_whitelist": ["foo", "bar"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final Blok? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
            "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Blok.fromJson).toList().firstOrNull"),
      );
    });
  });

  // MARK: - Text
  group("Test Text field", () {
    test("Test default text", () {
      final field = TextField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final String? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(valueExpression),
      );
    });
    test("Test required text", () {
      final field = TextField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final String foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(valueExpression),
      );
    });
  });

  // MARK: - Text area
  group("Test TextArea field", () {
    test("Test default textarea", () {
      final field = TextAreaField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final String? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(valueExpression),
      );
    });
    test("Test required textarea", () {
      final field = TextAreaField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode("final String foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(valueExpression),
      );
    });
  });

  // MARK: - Markdown
  group("Test Markdown field", () {
    test("Test default markdown", () {
      final field = MarkdownField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode("final $Markdown? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("$valueExpression == null ? null : $Markdown($valueExpression)"),
      );
    });
    test("Test required markdown", () {
      final field = MarkdownField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode("final $Markdown foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("$Markdown($valueExpression)"),
      );
    });
  });

  // MARK: - Number
  group("Test Number field", () {
    test("Test default number", () {
      final field = NumberField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode("final double? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("double.tryParse($valueExpression)"),
      );
    });
    test("Test required number", () {
      final field = NumberField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode("final double foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("double.parse($valueExpression)"),
      );
    });
    test("Test zero-decimal number", () {
      final field = NumberField.fromJson({"decimals": 0});
      expect(
        field.build("foo"),
        emitter.equalsCode("final int? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("int.tryParse($valueExpression)"),
      );
    });
    test("Test required zero-decimal number", () {
      final field = NumberField.fromJson({"required": true, "decimals": 0});
      expect(
        field.build("foo"),
        emitter.equalsCode("final int foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("int.parse($valueExpression)"),
      );
    });
  });

  // MARK: - DateTime
  group("Test DateTime field", () {
    test("Test default datetime", () {
      final field = DateTimeField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode("final DateTime? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("DateTime.tryParse($valueExpression)"),
      );
    });
    test("Test required datetime", () {
      final field = DateTimeField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final DateTime foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("DateTime.parse($valueExpression)"),
      );
    });
  });

  // MARK: - Boolean
  group("Test Boolean field", () {
    test("Test default boolean", () {
      final field = BooleanField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final bool foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("$valueExpression ?? false"),
      );
    });
    test("Test required datetime", () {
      final field = BooleanField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode("final bool foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(valueExpression),
      );
    });
  });

  // MARK: - RichText

  // MARK: - SingleOption

  // MARK: - MultiOption

  // MARK: - Asset

  // MARK: - MultiAsset

  // MARK: - Link

  // MARK: - Table

  // MARK: - Plugin
  group("Test Plugin field", () {
    test("Test default plugin", () {
      final field = PluginField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode("final $Plugin? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("$valueExpression is! Map<dynamic, dynamic> ? null : $Plugin.fromJson($valueExpression)"),
      );
    });
    test("Test required plugin", () {
      final field = PluginField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode("final $Plugin foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("$Plugin.fromJson($valueExpression)"),
      );
    });
  });
}
