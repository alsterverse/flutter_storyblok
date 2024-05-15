import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

class CodeEmitter {
  CodeEmitter({bool scoped = true})
      : _dartFormatter = DartFormatter(fixes: StyleFix.all, pageWidth: 120),
        _dartEmitter = DartEmitter(
          allocator: scoped ? Allocator.simplePrefixing() : Allocator.none,
          orderDirectives: true,
          useNullSafetySyntax: true,
        );

  final DartFormatter _dartFormatter;
  final DartEmitter _dartEmitter;

  String codeFromSpec(Spec spec) {
    final code = spec.accept(_dartEmitter).toString();
    final formattedCode = _dartFormatter.format(code);
    return formattedCode;
  }

  EqualsDart equalsCode(String code) {
    return equalsDart(code, _dartEmitter) as EqualsDart;
  }
}
