import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

class CodeEmitter {
  final _dartFormatter = DartFormatter(fixes: StyleFix.all, pageWidth: 120);
  final _dartEmitter = DartEmitter(orderDirectives: true, useNullSafetySyntax: true);

  String codeFromSpec(Spec spec) {
    final code = spec.accept(_dartEmitter).toString();
    final formattedCode = _dartFormatter.format(code);
    return formattedCode;
  }

  EqualsDart equalsCode(String code) {
    return equalsDart(code, _dartEmitter) as EqualsDart;
  }
}
