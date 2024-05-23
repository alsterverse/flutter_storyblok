import 'package:flutter_storyblok_code_generator/src/code_emitter.dart';
import 'package:flutter_storyblok_code_generator/src/enum.dart';
import 'package:test/test.dart';

void main() {
  final emitter = CodeEmitter(scoped: false);
  group('Test code generator enums', () {
    test('Test generate enum class', () {
      expect(
        buildEnum("Foo", [
          MapEntry("bar", "123"),
          MapEntry("baz", "  123 hello  "),
        ]),
        emitter.equalsCode(
          r"""
enum Foo {
  bar('123'),
  baz('  123 hello  '),
  unknown('unknown');

  const Foo(this.raw);

  factory Foo.fromName(String? name) {
    return switch (name) {
      '123' => Foo.bar,
      '  123 hello  ' => Foo.baz,
      _ => Foo.unknown,
    };
  }

  final String raw;
}
""",
        ),
      );
    });

    test('Test generate enum initializer code', () {
      expect(
        buildInstantiateEnum("Foo", "json['data']"),
        emitter.equalsCode(
          r"""
Foo.fromName(json['data'])
""",
        ),
      );
    });
  });
}
