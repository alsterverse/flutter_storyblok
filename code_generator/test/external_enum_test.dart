import 'package:flutter_storyblok_code_generator/src/code_emitter.dart';
import 'package:flutter_storyblok_code_generator/src/utils/build_enum.dart';
import 'package:flutter_storyblok_code_generator/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  final emitter = CodeEmitter(scoped: false);

  Future<List<JSONMap>> getExternalDatasourceEntries(Uri url) async {
    switch (url.toString()) {
      case "https://foo.bar/baz.json":
        return [
          {"name": "Foo", "value": "foo123"}
        ];
      default:
        throw "Failed";
    }
  }

  group('Test code generator external datasource enums', () {
    test('Test generate external datasource enum class', () async {
      final enumm =
          await buildEnumFromExternalSource(Uri.parse("https://foo.bar/baz.json"), getExternalDatasourceEntries);
      expect(
        enumm,
        emitter.equalsCode(
          r"""
// Datasource from https://foo.bar/baz.json
enum HttpsFooBarBazJson {
  foo('foo123'),
  unknown('unknown');

  const HttpsFooBarBazJson(this.raw);

  factory HttpsFooBarBazJson.fromName(String? name) {
    return switch (name) {
      'foo123' => HttpsFooBarBazJson.foo,
      _ => HttpsFooBarBazJson.unknown,
    };
  }

  final String raw;
}
""",
        ),
      );
    });

    test('Test generate failure external datasource enum class', () async {
      final enumm = await buildEnumFromExternalSource(Uri.parse("https://foo.bar/baz"), getExternalDatasourceEntries);
      expect(
        enumm,
        emitter.equalsCode(
          r"""
// Datasource from https://foo.bar/baz
// Error while fetching: Failed
enum HttpsFooBarBaz {
  unknown('unknown');

  const HttpsFooBarBaz(this.raw);

  factory HttpsFooBarBaz.fromName(String? name) {
    return switch (name) {
      _ => HttpsFooBarBaz.unknown,
    };
  }

  final String raw;
}
""",
        ),
      );
    });
  });
}
