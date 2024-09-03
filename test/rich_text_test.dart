import 'package:flutter_storyblok/fields.dart';
import 'package:test/test.dart';

void main() {
  group('Test parsing rich-text', () {
    test('Test parse rich-text basic text', () {
      final text = RichTextLeafText.fromJson({
        "type": "text",
        "text": "Hello world",
      });
      expect(text.text, "Hello world");
      expect(text.anchor, null);
      expect(text.backgroundColor, null);
      expect(text.foregroundColor, null);
      expect(text.isBold, false);
      expect(text.isCode, false);
      expect(text.isItalic, false);
      expect(text.isStriked, false);
      expect(text.isSubscript, false);
      expect(text.isSuperscript, false);
      expect(text.isUnderlined, false);
      expect(text.link, null);
    });

    test('Test parse rich-text text with foreground color', () {
      final text = RichTextLeafText.fromJson({
        "text": "Hello world",
        "marks": [
          {
            "type": "textStyle",
            "attrs": {"color": "#FF0000"}
          }
        ]
      });
      expect(text.foregroundColor!.colorString, "#FF0000");
    });

    test('Test parse rich-text text with foreground color css', () {
      final text = RichTextLeafText.fromJson({
        "text": "Hello world",
        "marks": [
          {
            "type": "textStyle",
            "attrs": {"color": "rgb(255, 0, 0)"}
          }
        ]
      });
      expect(text.foregroundColor!.colorString, "rgb(255, 0, 0)");
    });

    test('Test parse rich-text image', () {
      final image = RichTextLeafImage.fromJson({
        "type": "image",
        "attrs": {
          "id": 123,
          "alt": "hello",
          "src": "https://placehold.it/100x100",
          "title": "hello",
          "source": "hello",
          "copyright": "hello",
          "meta_data": {"alt": "hello"}
        }
      });
      expect(image.imageUrl, Uri.parse("https://placehold.it/100x100"));
      expect(image.alt, "hello");
      expect(image.metadata["alt"], "hello");
    });
  });
}
