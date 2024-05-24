import 'package:code_builder/code_builder.dart';
import 'package:flutter_storyblok_code_generator/src/code_emitter.dart';
import 'package:flutter_storyblok_code_generator/src/utils/build_sealed_class.dart';
import 'package:flutter_storyblok_code_generator/src/utils/code_builder_extensions.dart';
import 'package:flutter_storyblok_code_generator/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  final emitter = CodeEmitter(scoped: false);
  group("Test build sealed class", () {
    test('Test empty throw sealed class', () {
      final (:sealedClass, :classes) = buildBloksSealedClass(name: "foo", classes: [], throwUnrecognized: true);
      expect(
        sealedClass.build(),
        emitter.equalsCode(r"""
sealed class Foo {
  const Foo();

  factory Foo.fromJson(Map<String, dynamic> json) {
    final type = json['component'];
    return switch (type) { _ => throw 'Unrecognized type \'$type\' For class \'Foo\'' };
  }
}
"""),
      );
      expect(classes.length, 0, reason: "Subclasses should be empty");
    });

    test('Test throw sealed class', () {
      final (:sealedClass, :classes) = buildBloksSealedClass(
          name: "foo",
          classes: [
            (
              key: "bar",
              builder: ClassBuilder()
                ..name = "bar"
                ..fields.add(Field((f) => f
                  ..modifier = FieldModifier.final$
                  ..name = "bar"
                  ..type = "String".reference()))
                ..constructors.add(Constructor((con) => con
                  ..name = "fromJson"
                  ..requiredParameters.add(Parameter((p) => p
                    ..type = "$JSONMap".reference()
                    ..name = "json")) //
                  ..initializers.add("bar".expression.assign("json".expression.index(literalString("bar"))).code))),
              initializer: (Expression expression) => expression.code,
            )
          ],
          throwUnrecognized: false);
      expect(
        sealedClass.build(),
        emitter.equalsCode(r"""
sealed class Foo {
  const Foo();

  factory Foo.fromJson(Map<String, dynamic> json) {
    final type = json['component'];
    return switch (type) {
      'bar' => Bar.fromJson(json),
      _ => (){
        print('Unrecognized type \'$type\' For class \'Foo\'');
        return const UnrecognizedFoo();
      }()
    };
  }
}
"""),
      );
      expect(classes.length, 2, reason: "Number of subclasses should be 2");
      expect(
        classes[0],
        emitter.equalsCode(r"""
final class UnrecognizedFoo extends Foo {
  const UnrecognizedFoo();
}
"""),
      );
      expect(
        classes[1],
        emitter.equalsCode(r"""
final class Bar extends Foo {
  Bar.fromJson(Map<String, dynamic> json) : bar = json['bar'];

  final String bar;
}
"""),
      );
    });
  });
}
