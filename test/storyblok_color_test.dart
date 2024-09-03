import 'package:flutter_storyblok/widgets.dart';
import 'package:test/test.dart';

void main() {
  group('Test parsing colors from storyblok', () {
    test('Test parse color hexadecimal', () {
      final color = StoryblokColor.fromString("#FF8800");
      expect(color.alpha, 0xFF);
      expect(color.red, 0xFF);
      expect(color.green, 0x88);
      expect(color.blue, 0x00);
    });

    test('Test parse color css', () {
      final color = StoryblokColor.fromString("rgb(255, 136, 0)");
      expect(color.alpha, 0xFF);
      expect(color.red, 255);
      expect(color.green, 136);
      expect(color.blue, 0);
    });
  });
}
