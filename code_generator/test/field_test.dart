import 'package:code_builder/code_builder.dart' as cb;
import 'package:flutter_storyblok/fields.dart';
import 'package:flutter_storyblok_code_generator/src/code_emitter.dart';
import 'package:flutter_storyblok_code_generator/src/fields/asset_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/blok_fields.dart';
import 'package:flutter_storyblok_code_generator/src/fields/boolean_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/datetime_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/link_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/multi_asset_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/number_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/option_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/options_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/plugin_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/rich_text_field.dart';
import 'package:flutter_storyblok_code_generator/src/fields/table_field.dart';
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
      final field = BlokField.fromJson({}, "foo", "bar");
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
      final field = BlokField.fromJson({"required": true}, "foo", "bar");
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
      }, "foo", "bar");
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final List<Foo> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Foo.fromJson).toList()"),
      );
    });
    test("Test multi-restricted blok", () async {
      final field = BlokField.fromJson({
        "restrict_components": true,
        "component_whitelist": ["foo", "bar"],
      }, "foo", "bar");
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final List<BarFooRestrictedTypes> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
            "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(BarFooRestrictedTypes.fromJson).toList()"),
      );
      final enu = List<cb.Class>.from(field.buildSupportingClass() ?? []);
      expect(enu.length, 3);
      expect(enu[0].name, "BarFooRestrictedTypes");
      expect(enu[1].name, "BarFooRestrictedTypesFoo");
      expect(enu[2].name, "BarFooRestrictedTypesBar");
    });
    test("Test single restricted blok", () {
      final field = BlokField.fromJson({
        "maximum": 1,
        "restrict_components": true,
        "component_whitelist": ["foo"],
      }, "foo", "bar");
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
      }, "foo", "bar");
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
      }, "foo", "bar");
      expect(
        field.build("foo"),
        emitter.equalsCode(r"final BarFooRestrictedTypes? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
            "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(BarFooRestrictedTypes.fromJson).toList().firstOrNull"),
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
  group("Test RichText field", () {
    test("Test default richtext", () {
      final field = RichTextField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode("final RichText? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("$valueExpression == null ? null : RichText.fromJson($valueExpression)"),
      );
    });

    test("Test required richtext", () {
      final field = RichTextField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode("final RichText foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("RichText.fromJson($valueExpression)"),
      );
    });
  });

  // MARK: - SingleOption
  group("Test SingleOption field", () {
    test("Test default singleoption", () {
      final field = OptionField.fromJson({}, "foo", "bar");
      expect(field.shouldSkip, true);
    });
    test("Test self singleoption", () async {
      final field = OptionField.fromJson({
        "source": "self",
        "options": [
          {"name": "Foo", "value": "foo123"},
          {"name": "Bar", "value": "  bar !?=)€(%&/& 123 åäö "},
        ],
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final BarFooOption foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("BarFooOption.fromName($valueExpression)"),
      );
      final classes = field.buildSupportingClass();
      expect(classes?.length, 1);
      final enumm = classes!.cast<cb.Enum>().first;
      expect(
        enumm.values.map(
          (e) => (e.name, e.arguments.first.code.toString()),
        ),
        [
          ("foo", "'foo123'"),
          ("bar", "'  bar !?=)€(%&/& 123 åäö '"),
          ("unknown", "'unknown'"),
        ],
      );
    });
    test("Test story singleoption", () {
      final field = OptionField.fromJson({
        "source": "internal_stories",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final StoryIdentifierUUID? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("$valueExpression == null ? null : StoryIdentifierUUID($valueExpression)"),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
    });
    test("Test required story singleoption", () {
      final field = OptionField.fromJson({
        "required": true,
        "source": "internal_stories",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final StoryIdentifierUUID foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("StoryIdentifierUUID($valueExpression)"),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
    });
    test("Test language singleoption", () {
      final field = OptionField.fromJson({
        "source": "internal_languages",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final String? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(valueExpression),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
    });
    test("Test required language singleoption", () {
      final field = OptionField.fromJson({
        "required": true,
        "source": "internal_languages",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final String foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(valueExpression),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
    });
    test("Test default datasource singleoption", () {
      final field = OptionField.fromJson({
        "source": "internal",
      }, "foo", "bar");
      expect(field.shouldSkip, true);
    });
    test("Test internal singleoption", () {
      final field = OptionField.fromJson({
        "source": "internal",
        "datasource_slug": "foo",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final Foo foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("Foo.fromName($valueExpression)"),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
    });
    test("Test default external singleoption", () {
      final field = OptionField.fromJson({
        "source": "external",
      }, "foo", "bar");
      expect(field.shouldSkip, true);
    });
    test("Test external singleoption", () async {
      final field = OptionField.fromJson({
        "source": "external",
        "external_datasource": "https://foo.bar/baz.json",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final HttpsFooBarBazJson foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("HttpsFooBarBazJson.fromName($valueExpression)"),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
      expect(
        field.getExternalDatasourceUrl(),
        Uri.parse("https://foo.bar/baz.json"),
      );
    });
    test("Test failed fetch external singleoption", () async {
      final field = OptionField.fromJson({
        "source": "external",
        "external_datasource": "https://foo.bar/baz",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final HttpsFooBarBaz foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("HttpsFooBarBaz.fromName($valueExpression)"),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
      expect(
        field.getExternalDatasourceUrl(),
        Uri.parse("https://foo.bar/baz"),
      );
    });
  });

  // MARK: - MultiOption
  group("Test MultiOption field", () {
    test("Test default multioption", () {
      final field = OptionsField.fromJson({}, "foo", "bar");
      expect(field.shouldSkip, true);
    });
    test("Test self multioption", () async {
      final field = OptionsField.fromJson({
        "source": "self",
        "options": [
          {"name": "Foo", "value": "foo123"},
          {"name": "Bar", "value": "  bar !?=)€(%&/& 123 åäö "},
        ],
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<BarFooOption> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<String>.from($valueExpression ?? const []).map(BarFooOption.fromName).toList()"),
      );
      final classes = field.buildSupportingClass();
      expect(classes?.length, 1);
      final enumm = classes!.cast<cb.Enum>().first;
      expect(
        enumm.values.map(
          (e) => (e.name, e.arguments.first.code.toString()),
        ),
        [
          ("foo", "'foo123'"),
          ("bar", "'  bar !?=)€(%&/& 123 åäö '"),
          ("unknown", "'unknown'"),
        ],
      );
    });
    test("Test story multioption", () {
      final field = OptionsField.fromJson({
        "source": "internal_stories",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<StoryIdentifierUUID> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<String>.from($valueExpression ?? const []).map(StoryIdentifierUUID.new).toList()"),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
    });
    test("Test language multioption", () {
      final field = OptionsField.fromJson({
        "source": "internal_languages",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<String> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<String>.from($valueExpression ?? const [])"),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
    });
    test("Test default datasource multioption", () {
      final field = OptionsField.fromJson({
        "source": "internal",
      }, "foo", "bar");
      expect(field.shouldSkip, true);
    });
    test("Test internal multioption", () {
      final field = OptionsField.fromJson({
        "source": "internal",
        "datasource_slug": "foo",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<Foo> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<String>.from($valueExpression ?? const []).map(Foo.fromName).toList()"),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
    });
    test("Test default external multioption", () {
      final field = OptionsField.fromJson({
        "source": "external",
      }, "foo", "bar");
      expect(field.shouldSkip, true);
    });
    test("Test external multioption", () async {
      final field = OptionsField.fromJson({
        "source": "external",
        "external_datasource": "https://foo.bar/baz.json",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<HttpsFooBarBazJson> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<String>.from($valueExpression ?? const []).map(HttpsFooBarBazJson.fromName).toList()"),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
      expect(
        field.getExternalDatasourceUrl(),
        Uri.parse("https://foo.bar/baz.json"),
      );
    });
    test("Test failed fetch external multioption", () async {
      final field = OptionsField.fromJson({
        "source": "external",
        "external_datasource": "https://foo.bar/baz",
      }, "foo", "bar");
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<HttpsFooBarBaz> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("List<String>.from($valueExpression ?? const []).map(HttpsFooBarBaz.fromName).toList()"),
      );
      expect(
        field.buildSupportingClass(),
        null,
      );
      expect(
        field.getExternalDatasourceUrl(),
        Uri.parse("https://foo.bar/baz"),
      );
    });
  });

  // MARK: - Asset
  group("Test Asset field", () {
    test("Test default asset", () {
      final field = AssetField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode("final Asset? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("$valueExpression == null ? null : Asset.fromJson($valueExpression)"),
      );
    });
    test("Test required asset", () {
      final field = AssetField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode("final Asset foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("Asset.fromJson($valueExpression)"),
      );
    });
    test("Test image asset", () {
      final field = AssetField.fromJson({
        "required": true,
        "filetypes": ["images"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final ImageAsset foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("ImageAsset.fromJson($valueExpression)"),
      );
    });
    test("Test video asset", () {
      final field = AssetField.fromJson({
        "required": true,
        "filetypes": ["videos"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final VideoAsset foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("VideoAsset.fromJson($valueExpression)"),
      );
    });
    test("Test audio asset", () {
      final field = AssetField.fromJson({
        "required": true,
        "filetypes": ["audios"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final AudioAsset foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("AudioAsset.fromJson($valueExpression)"),
      );
    });
    test("Test text asset", () {
      final field = AssetField.fromJson({
        "required": true,
        "filetypes": ["texts"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final TextAsset foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("TextAsset.fromJson($valueExpression)"),
      );
    });
    test("Test omni-asset", () {
      final field = AssetField.fromJson({
        "required": true,
        "filetypes": ["images", "videos", "audios", "texts"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final Asset foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("Asset.fromJson($valueExpression)"),
      );
    });
  });

  // MARK: - MultiAsset
  group("Test MultiAsset field", () {
    test("Test default multiasset", () {
      final field = MultiAssetField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<Asset> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
          "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Asset.fromJson).toList()",
        ),
      );
    });
    test("Test required multiasset", () {
      final field = MultiAssetField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<Asset> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
          "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Asset.fromJson).toList()",
        ),
      );
    });
    test("Test image multiasset", () {
      final field = MultiAssetField.fromJson({
        "required": true,
        "filetypes": ["images"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<ImageAsset> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
          "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(ImageAsset.fromJson).toList()",
        ),
      );
    });
    test("Test video multiasset", () {
      final field = MultiAssetField.fromJson({
        "required": true,
        "filetypes": ["videos"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<VideoAsset> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
          "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(VideoAsset.fromJson).toList()",
        ),
      );
    });
    test("Test audio multiasset", () {
      final field = MultiAssetField.fromJson({
        "required": true,
        "filetypes": ["audios"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<AudioAsset> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
          "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(AudioAsset.fromJson).toList()",
        ),
      );
    });
    test("Test text multiasset", () {
      final field = MultiAssetField.fromJson({
        "required": true,
        "filetypes": ["texts"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<TextAsset> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
          "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(TextAsset.fromJson).toList()",
        ),
      );
    });
    test("Test omni-multiasset", () {
      final field = MultiAssetField.fromJson({
        "required": true,
        "filetypes": ["images", "videos", "audios", "texts"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final List<Asset> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
          "List<Map<String, dynamic>>.from($valueExpression ?? const []).map(Asset.fromJson).toList()",
        ),
      );
    });
  });

  // MARK: - Link
  group("Test Link field", () {
    test("Test default link", () {
      final field = LinkField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode("final DefaultLink<Blok>? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
            "$valueExpression is! Map<dynamic, dynamic> ? null : DefaultLink<Blok>.fromJson($valueExpression)"),
      );
    });
    test("Test required link", () {
      final field = LinkField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode("final DefaultLink<Blok> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("DefaultLink<Blok>.fromJson($valueExpression)"),
      );
    });
    test("Test asset link", () {
      final field = LinkField.fromJson({
        "required": true,
        "asset_link_type": true,
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final DefaultWithAssetLink<Blok> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("DefaultWithAssetLink<Blok>.fromJson($valueExpression)"),
      );
    });
    test("Test email link", () {
      final field = LinkField.fromJson({
        "required": true,
        "email_link_type": true,
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final DefaultWithEmailLink<Blok> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("DefaultWithEmailLink<Blok>.fromJson($valueExpression)"),
      );
    });
    test("Test omni-link", () {
      final field = LinkField.fromJson({
        "required": true,
        "asset_link_type": true,
        "email_link_type": true,
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final Link<Blok> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("Link<Blok>.fromJson($valueExpression)"),
      );
    });
    test("Test constrained story link", () {
      final field = LinkField.fromJson({
        "required": true,
        "restrict_content_types": true,
        "component_whitelist": ["foo"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final DefaultLink<Foo> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("DefaultLink<Foo>.fromJson($valueExpression)"),
      );
    });
    test("Test constrained story omni-link", () {
      final field = LinkField.fromJson({
        "required": true,
        "asset_link_type": true,
        "email_link_type": true,
        "restrict_content_types": true,
        "component_whitelist": ["foo"],
      });
      expect(
        field.build("foo"),
        emitter.equalsCode("final Link<Foo> foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("Link<Foo>.fromJson($valueExpression)"),
      );
    });
  });

  // MARK: - Table
  group("Test Table field", () {
    test("Test default table", () {
      final field = TableField.fromJson({});
      expect(
        field.build("foo"),
        emitter.equalsCode("final Table foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("Table.fromJson($valueExpression)"),
      );
    });
    test("Test required table", () {
      final field = TableField.fromJson({"required": true});
      expect(
        field.build("foo"),
        emitter.equalsCode("final Table foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("Table.fromJson($valueExpression)"),
      );
    });
  });

  // MARK: - Plugin
  group("Test Plugin field", () {
    test("Test default plugin", () {
      final field = PluginField.fromJson({});
      expect(field.shouldSkip, true);
    });
    test("Test basic plugin", () {
      final field = PluginField.fromJson({"field_type": "bar"});
      expect(field.shouldSkip, false);
      expect(
        field.build("foo"),
        emitter.equalsCode("final $Plugin? foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode(
            "$valueExpression is! Map<dynamic, dynamic> ? null : $Plugin.fromJson($valueExpression, 'bar', )"),
      );
    });
    test("Test required plugin", () {
      final field = PluginField.fromJson({"required": true, "field_type": "bar"});
      expect(
        field.build("foo"),
        emitter.equalsCode("final $Plugin foo;"),
      );
      expect(
        field.buildInitializer(valueExpression.expression),
        emitter.equalsCode("$Plugin.fromJson($valueExpression, 'bar', )"),
      );
    });
  });
}
