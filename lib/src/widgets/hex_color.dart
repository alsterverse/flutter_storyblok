import 'package:flutter/material.dart';

/// Used to convert a color hex string to a Flutter Color
final class HexColor extends Color {
  static final cssColorRegex = RegExp(r"rgb\((\d{1,3}),\s?(\d{1,3}),\s?(\d{1,3})\)", caseSensitive: false);

  static int _getColorFromHex(String hexColor) {
    final cssColorMatch = cssColorRegex.firstMatch(hexColor);
    if (cssColorMatch != null) {
      final r = int.parse(cssColorMatch.group(1)!);
      final g = int.parse(cssColorMatch.group(2)!);
      final b = int.parse(cssColorMatch.group(3)!);
      return 0xFF << 8 * 3 | //
          r << 8 * 2 | //
          g << 8 * 1 | //
          b << 8 * 0;
    } else {
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 6) hexColor = "FF$hexColor";
      return int.parse(hexColor, radix: 16);
    }
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
