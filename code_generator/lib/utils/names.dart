import 'package:dart_casing/dart_casing.dart';

Map<String, String> _sanitizedNames = {};

String _sanitizedNameKey(String raw, bool isClass) => "${isClass ? "class" : ""}$raw";

String sanitizeName(final String raw, {required bool isClass}) {
  final cached = _sanitizedNames["${isClass ? "class" : ""}$raw"];
  if (cached != null) return cached;
  // Trim and replace spaces with _
  var sanitized = raw.trim().replaceAll(RegExp(r"\s"), "_");
  // camelCase to snake_case to retain an already camelCase. "(?=)" (lookahead) is a trick to keep the delimiter.
  sanitized = sanitized.split(RegExp(r"(?=[A-Z])")).join("_");
  // If string starts with an illegal character or is a keyword, prefix a `$` to it.
  if (sanitized.startsWith(RegExp(r"^([^\$a-zA-Z])")) || (!isClass && _dartKeywords.contains(sanitized))) {
    sanitized = "\$$sanitized";
  }
  sanitized = isClass ? Casing.pascalCase(sanitized) : Casing.camelCase(sanitized);
  // If the string was sanitized add it to cache
  _sanitizedNames[_sanitizedNameKey(raw, isClass)] = sanitized;
  return sanitized;
}

String unsanitizedName(String sanitized) {
  if (sanitized.startsWith("\$")) return sanitized.substring(1);
  return sanitized;
}

const _dartKeywords = [
  "abstract",
  "as",
  "assert",
  "async",
  "await",
  "base",
  "break",
  "case",
  "catch",
  "class",
  "const",
  "continue",
  "covariant",
  "default",
  "deferred",
  "do",
  "dynamic",
  "else",
  "enum",
  "export",
  "extends",
  "extension",
  "external",
  "factory",
  "false",
  "final",
  "final",
  "finally",
  "forFunction",
  "get",
  "hide",
  "if",
  "implements",
  "import",
  "in",
  "interfaceis",
  "late",
  "library",
  "mixin",
  "new",
  "null",
  "of",
  "onoperator",
  "part",
  "required",
  "rethrow",
  "return",
  "sealed",
  "set",
  "show",
  "static",
  "super",
  "switch",
  "sync",
  "this",
  "throw",
  "true",
  "try",
  "type",
  "typedef",
  "var",
  "void",
  "when",
  "with",
  "while",
  "yield",
];
