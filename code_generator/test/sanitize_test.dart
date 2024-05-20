import 'package:flutter_storyblok_code_generator/src/names.dart';
import 'package:test/test.dart';

void main() {
  group("Test identifier sanitization", () {
    test("Test sanitize illegal characters", () {
      expect(sanitizeName("Narrow (80px)", isClass: false), "narrow80Px");
      expect(sanitizeName("Narrow (80px)", isClass: true), "Narrow80Px");

      expect(sanitizeName("/Narrow (-80px)", isClass: false), "narrow80Px");
      expect(sanitizeName("/Narrow (-80px)", isClass: true), "Narrow80Px");

      expect(sanitizeName("Red (#FF0000)", isClass: false), "redFF0000");
      expect(sanitizeName("Red (#FF0000)", isClass: true), "RedFF0000");

      expect(sanitizeName("Red-Green-(#FFFF00)", isClass: false), "redGreenFFFF00");
      expect(sanitizeName("Red-Green-(#FFFF00)", isClass: true), "RedGreenFFFF00");
    });

    test("Test sanitize starting character", () {
      expect(sanitizeName("80 pieces", isClass: false), "\$80Pieces");
      expect(sanitizeName("80 pieces", isClass: true), "\$80Pieces");

      expect(sanitizeName(" 80 pieces ", isClass: false), "\$80Pieces");
      expect(sanitizeName(" 80 pieces ", isClass: true), "\$80Pieces");
    });

    test("Test sanitize keywords", () {
      expect(sanitizeName("Default", isClass: false), "default\$");
      expect(sanitizeName("Default", isClass: true), "Default");

      expect(sanitizeName("external", isClass: false), "external\$");
      expect(sanitizeName("external", isClass: true), "External");

      expect(sanitizeName("123 external", isClass: false), "\$123External");
      expect(sanitizeName("123 external", isClass: true), "\$123External");
    });
  });
}
