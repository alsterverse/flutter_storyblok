import 'package:flutter/material.dart';

/// Used to convert a color hex string to a Flutter Color
final class StoryblokColor extends Color {
  StoryblokColor(super.value);
  factory StoryblokColor.fromString(String colorString) {
    final cssColorMatch = cssColorRegex.firstMatch(colorString);
    if (cssColorMatch != null) return StoryblokColor(_getColorFromCSS(cssColorMatch));
    return StoryblokColor(_getColorFromHex(colorString));
  }

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    return int.parse(hexColor, radix: 16);
  }

  static final cssColorRegex = RegExp(r"rgb\((\d{1,3}),\s?(\d{1,3}),\s?(\d{1,3})\)", caseSensitive: false);
  static int _getColorFromCSS(RegExpMatch match) {
    final r = int.parse(match.group(1)!);
    final g = int.parse(match.group(2)!);
    final b = int.parse(match.group(3)!);
    return 0xFF << 8 * 3 | //
        r << 8 * 2 | //
        g << 8 * 1 | //
        b << 8 * 0;
  }
}
