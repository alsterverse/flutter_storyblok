import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storyblok/fields.dart' as fields;
import 'package:flutter_storyblok/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

import 'storyblok_rich_text_test.dart' show inScaffold, paragraphJson, textJson;

const linkCount = 3;
const buildCount = 20;

/// Returns the JSON of a paragraph holding [linkCount] links whose texts and paths are prefixed with [prefix].
Map<String, dynamic> linkParagraph([String prefix = "Link", String host = "example.com"]) => paragraphJson([
  for (var i = 0; i < linkCount; i++)
    textJson("$prefix $i", [
      {
        "type": "link",
        "attrs": {"linktype": "url", "href": "https://$host/$prefix/$i"},
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

/// Returns the recognizers of the rendered spans whose text is [text], in order.
List<GestureRecognizer?> recognizersOf(WidgetTester tester, String text) => [
  for (final richText in tester.widgetList<RichText>(find.byType(RichText)))
    for (final span in (richText.text as TextSpan).children ?? const <InlineSpan>[])
      if (span is TextSpan && span.text == text) span.recognizer,
];

/// Returns the recognizer of the single rendered span whose text is [text].
GestureRecognizer? recognizerOf(WidgetTester tester, String text) => recognizersOf(tester, text).single;

/// Returns the global center of the rendered [text].
Offset textCenter(String text) {
  final range = find.textRange.ofSubstring(text).evaluate().single;
  final box = range.renderObject
      .getBoxesForSelection(TextSelection(baseOffset: range.textRange.start, extentOffset: range.textRange.end))
      .first;
  return range.renderObject.localToGlobal(box.toRect().center);
}

/// Returns the objects disposed while [action] runs, so a test can tell disposal on rebuild from disposal on unmount.
Future<List<Object>> disposedDuring(Future<void> Function() action) async {
  final disposed = <Object>[];
  void collectDisposed(ObjectEvent event) {
    if (event is ObjectDisposed) disposed.add(event.object);
  }

  FlutterMemoryAllocations.instance.addListener(collectDisposed);
  await action();
  FlutterMemoryAllocations.instance.removeListener(collectDisposed);
  return disposed;
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

  for (final reparse in [false, true]) {
    final contentKind = reparse ? 're-parsed equal content' : 'the same content';
    List<fields.RichTextContainer> nextContent(List<fields.RichTextContainer> content) =>
        reparse ? parseLinks() : content;

    testWidgets('Rebuild with $contentKind keeps the recognizer', (tester) async {
      final content = parseLinks();
      await pumpContent(tester, content, onTapLink: (_) {});
      final recognizer = recognizerOf(tester, "Link 1");
      await pumpContent(tester, nextContent(content), onTapLink: (_) {});
      expect(recognizer, isA<TapGestureRecognizer>());
      expect(identical(recognizerOf(tester, "Link 1"), recognizer), isTrue);
    });

    testWidgets('Tap in progress during a rebuild with $contentKind calls onTapLink', (tester) async {
      final content = parseLinks();
      final tapped = <fields.Link>[];
      await pumpContent(tester, content, onTapLink: tapped.add);
      final gesture = await tester.startGesture(textCenter("Link 1"));
      await pumpContent(tester, nextContent(content), onTapLink: tapped.add);
      await gesture.up();
      expect((tapped.single as fields.LinkURL).url, Uri.parse("https://example.com/Link/1"));
    });
  }

  testWidgets('Tap after onTapLink changes on the same content calls the new onTapLink', (tester) async {
    final content = parseLinks();
    final oldTapped = <fields.Link>[];
    final newTapped = <fields.Link>[];
    await pumpContent(tester, content, onTapLink: oldTapped.add);
    await pumpContent(tester, content, onTapLink: newTapped.add);
    expect(await tapLink(tester, "Link 1", newTapped), Uri.parse("https://example.com/Link/1"));
    expect(oldTapped, isEmpty);
  });

  testWidgets('Equal links with the same text get their own recognizers, kept across a rebuild', (tester) async {
    final duplicateLink = textJson("Same", [
      {
        "type": "link",
        "attrs": {"linktype": "url", "href": "https://example.com/same"},
      },
    ]);
    List<fields.RichTextContainer> parseDuplicates() => [
      fields.RichTextContainer.fromJson(paragraphJson([duplicateLink, duplicateLink])),
    ];
    await pumpContent(tester, parseDuplicates(), onTapLink: (_) {});
    final recognizers = recognizersOf(tester, "Same");
    expect(recognizers, hasLength(2));
    expect(identical(recognizers.first, recognizers.last), isFalse);
    await pumpContent(tester, parseDuplicates(), onTapLink: (_) {});
    final rebuiltRecognizers = recognizersOf(tester, "Same");
    expect(identical(rebuiltRecognizers.first, recognizers.first), isTrue);
    expect(identical(rebuiltRecognizers.last, recognizers.last), isTrue);
  });

  testWidgets('Rebuild with the same text linking elsewhere replaces the recognizer', (tester) async {
    final tapped = <fields.Link>[];
    await pumpContent(tester, parseLinks(), onTapLink: tapped.add);
    final oldRecognizer = recognizerOf(tester, "Link 1");
    final disposed = await disposedDuring(
      () => pumpContent(
        tester,
        [fields.RichTextContainer.fromJson(linkParagraph("Link", "other.example.com"))],
        onTapLink: tapped.add,
      ),
    );
    expect(disposed, contains(oldRecognizer));
    expect(identical(recognizerOf(tester, "Link 1"), oldRecognizer), isFalse);
    expect(await tapLink(tester, "Link 1", tapped), Uri.parse("https://other.example.com/Link/1"));
  });

  testWidgets('Removing onTapLink on the same content removes the recognizer', (tester) async {
    final content = parseLinks();
    await pumpContent(tester, content, onTapLink: (_) {});
    final recognizer = recognizerOf(tester, "Link 1");
    expect(await disposedDuring(() => pumpContent(tester, content)), contains(recognizer));
    expect(recognizerOf(tester, "Link 1"), isNull);
  });

  testWidgets('Removing a container keeps the recognizers of the remaining links', (tester) async {
    final content = parseLinks(["A", "B"]);
    await pumpContent(tester, content, onTapLink: (_) {});
    final removedRecognizer = recognizerOf(tester, "A 1");
    final recognizer = recognizerOf(tester, "B 1");
    final disposed = await disposedDuring(() => pumpContent(tester, [content.last], onTapLink: (_) {}));
    expect(find.textRange.ofSubstring("A 1"), findsNothing);
    expect(disposed, contains(removedRecognizer));
    expect(disposed, isNot(contains(recognizer)));
    expect(identical(recognizerOf(tester, "B 1"), recognizer), isTrue);
  });
}
