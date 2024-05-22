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

  String _format(String source) {
    try {
      return _dartFormatter.format(source);
    } on FormatterException catch (_) {
      return _dartFormatter.formatStatement(source);
    }
  }

  equalsCode(String code) {
    /// Should be invoked in `main()` of every test in `test/**_test.dart`.
    EqualsDart.format = _format;
    return equalsDart(code, _dartEmitter);
  }
}
