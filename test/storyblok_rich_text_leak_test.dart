import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storyblok/fields.dart' as fields;
import 'package:flutter_storyblok/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

import 'storyblok_rich_text_test.dart' show inScaffold, paragraphJson, textJson;

const linkCount = 3;
const buildCount = 20;

/// Returns the JSON of a paragraph holding [linkCount] links whose texts and hrefs are prefixed with [prefix].
Map<String, dynamic> linkParagraph([String prefix = "Link"]) => paragraphJson([
  for (var i = 0; i < linkCount; i++)
    textJson("$prefix $i", [
      {
        "type": "link",
        "attrs": {"linktype": "url", "href": "https://example.com/$prefix/$i"},
      },
    ]),
]);

/// Parses new container and leaf instances from the JSON of a [linkParagraph] per prefix in [prefixes].
List<fields.RichTextContainer> parseLinks([List<String> prefixes = const ["Link"]]) =>
    prefixes.map((prefix) => fields.RichTextContainer.fromJson(linkParagraph(prefix))).toList();

/// Pumps a new [StoryblokRichText] widget showing [content], rebuilding the mounted one.
Future<void> pumpContent(
  WidgetTester tester,
  List<fields.RichTextContainer> content, {
  void Function(fields.Link)? onTapLink,
}) => tester.pumpWidget(
  inScaffold(
    StoryblokRichText(content: content, onTapLink: onTapLink, blockBuilder: (_, _) => const SizedBox.shrink()),
  ),
);

/// Pumps [buildCount] rebuilds, each with newly parsed content, then unmounts [StoryblokRichText].
Future<void> pumpRebuildsAndUnmount(WidgetTester tester, {void Function(fields.Link)? onTapLink}) async {
  for (var i = 0; i < buildCount; i++) {
    await pumpContent(tester, parseLinks(), onTapLink: onTapLink);
  }
  await tester.pumpWidget(const SizedBox.shrink());
}

/// Returns the recognizer of the rendered span whose text is [text].
GestureRecognizer? recognizerOf(WidgetTester tester, String text) {
  GestureRecognizer? recognizer;
  for (final richText in tester.widgetList<RichText>(find.byType(RichText))) {
    richText.text.visitChildren((span) {
      if (span is TextSpan && span.text == text) recognizer = span.recognizer;
      return recognizer == null;
    });
  }
  return recognizer;
}

/// Returns the global center of the rendered [text].
Offset textCenter(String text) {
  final range = find.textRange.ofSubstring(text).evaluate().single;
  final box = range.renderObject
      .getBoxesForSelection(TextSelection(baseOffset: range.textRange.start, extentOffset: range.textRange.end))
      .first;
  return range.renderObject.localToGlobal(box.toRect().center);
}

/// Taps the rendered [text] and returns the URL of the single link [tapped] received.
Future<Uri> tapLink(WidgetTester tester, String text, List<fields.Link> tapped) async {
  await tester.tapOnText(find.textRange.ofSubstring(text));
  return (tapped.single as fields.LinkURL).url;
}

void main() {
  // The default reporter fails the run if any test in this file leaves a disposable undisposed.
  LeakTesting.enable();

  testWidgets('Links without onTapLink, rebuilt $buildCount times, leak nothing', (tester) async {
    await pumpRebuildsAndUnmount(tester);
  });

  testWidgets('Links with onTapLink, rebuilt $buildCount times, leak nothing', (tester) async {
    await pumpRebuildsAndUnmount(tester, onTapLink: (_) {});
  });

  testWidgets('Rebuild with the same content keeps the recognizer', (tester) async {
    final content = parseLinks();
    await pumpContent(tester, content, onTapLink: (_) {});
    final recognizer = recognizerOf(tester, "Link 1");
    await pumpContent(tester, content, onTapLink: (_) {});
    expect(recognizer, isA<TapGestureRecognizer>());
    expect(identical(recognizerOf(tester, "Link 1"), recognizer), isTrue);
  });

  testWidgets('Tap in progress during a rebuild with the same content calls onTapLink', (tester) async {
    final content = parseLinks();
    final tapped = <fields.Link>[];
    await pumpContent(tester, content, onTapLink: tapped.add);
    final gesture = await tester.startGesture(textCenter("Link 1"));
    await pumpContent(tester, content, onTapLink: tapped.add);
    await gesture.up();
    expect((tapped.single as fields.LinkURL).url, Uri.parse("https://example.com/Link/1"));
  });

  testWidgets('Tap after onTapLink changes on the same content calls the new onTapLink', (tester) async {
    final content = parseLinks();
    final oldTapped = <fields.Link>[];
    final newTapped = <fields.Link>[];
    await pumpContent(tester, content, onTapLink: oldTapped.add);
    await pumpContent(tester, content, onTapLink: newTapped.add);
    expect(await tapLink(tester, "Link 1", newTapped), Uri.parse("https://example.com/Link/1"));
    expect(oldTapped, isEmpty);
  });

  testWidgets('Tap after content is replaced calls onTapLink with the new link', (tester) async {
    final tapped = <fields.Link>[];
    await pumpContent(tester, parseLinks(), onTapLink: tapped.add);
    final oldRecognizer = recognizerOf(tester, "Link 1");
    await pumpContent(tester, parseLinks(), onTapLink: tapped.add);
    expect(identical(recognizerOf(tester, "Link 1"), oldRecognizer), isFalse);
    expect(await tapLink(tester, "Link 1", tapped), Uri.parse("https://example.com/Link/1"));
  });

  testWidgets('Removing onTapLink on the same content removes the recognizer', (tester) async {
    final content = parseLinks();
    await pumpContent(tester, content, onTapLink: (_) {});
    await pumpContent(tester, content);
    expect(recognizerOf(tester, "Link 1"), isNull);
  });

  testWidgets('Removing a container keeps the recognizers of the remaining links', (tester) async {
    final content = parseLinks(["A", "B"]);
    await pumpContent(tester, content, onTapLink: (_) {});
    final recognizer = recognizerOf(tester, "B 1");
    await pumpContent(tester, [content.last], onTapLink: (_) {});
    expect(find.textRange.ofSubstring("A 1"), findsNothing);
    expect(identical(recognizerOf(tester, "B 1"), recognizer), isTrue);
  });
}
