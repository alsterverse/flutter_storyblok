import 'package:characters/characters.dart';
import 'package:dart_casing/dart_casing.dart';

// Only ASCII, _ and $ characters allowed
const _startIllegalCharacters = r"_\$a-zA-Z";
final _startIllegalCharactersRegex = RegExp("[^$_startIllegalCharacters]");
final _illegalCharactersRegex = RegExp("[^${_startIllegalCharacters}0-9]");

/// "(?=)" (lookahead) is a trick to keep the delimiter
final _camelCasePattern = RegExp(r"(?=[A-Z])");

Map<String, String> _sanitizedNames = {};

String _sanitizedNameKey(String raw, bool isClass) => "${isClass ? "class" : ""}$raw";

String sanitizeName(String raw, {required bool isClass}) {
  final cached = _sanitizedNames[_sanitizedNameKey(raw, isClass)];
  if (cached != null) return cached;

  // Trim and replace illegal identifiers with _
  var sanitized = raw.trim().replaceAll(_illegalCharactersRegex, "_");

  // camelCase to snake_case to retain an already camelCase.
  sanitized = sanitized.split(_camelCasePattern).join("_");

  sanitized = isClass ? Casing.pascalCase(sanitized) : Casing.camelCase(sanitized);

  // If string starts with an illegal character, prefix the name with `$`.
  if (sanitized.startsWith(_startIllegalCharactersRegex)) {
    sanitized = "\$$sanitized";
  }
  // If string is a Dart keyword, suffix the name with `$`. No need if it's a class name since it will be capitalized.
  if (!isClass && _dartKeywords.contains(sanitized.toLowerCase())) {
    sanitized = "$sanitized\$";
  }

  // Cache the sanitized name for `raw`
  _sanitizedNames[_sanitizedNameKey(raw, isClass)] = sanitized;
  return sanitized;
}

String unsanitizedName(String sanitized) {
  if (sanitized.startsWith("\$")) return sanitized.substring(1);
  if (sanitized.endsWith("\$")) return sanitized.characters.skipLast(1).string;
  return sanitized;
}

/// As of Dart 3.3.0 https://dart.dev/language/keywords
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
