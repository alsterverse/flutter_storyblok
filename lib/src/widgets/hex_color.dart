import 'package:flutter/material.dart';

/// Used to convert a color hex string to a Flutter Color
final class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.tryParse(hexColor, radix: 16) ?? 0xff000000;
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
