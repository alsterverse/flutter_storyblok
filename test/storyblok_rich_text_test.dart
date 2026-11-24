// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/fields.dart' as fields;
import 'package:flutter_storyblok/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Returns the JSON of a text leaf with [text] and [marks].
Map<String, dynamic> textJson(String text, [List<Map<String, dynamic>> marks = const []]) => {
  "type": "text",
  "text": text,
  "marks": marks,
};

/// Returns the JSON of a container of [type] holding [content] and [attrs].
Map<String, dynamic> containerJson(String type, List<Map<String, dynamic>> content, {Map<String, dynamic>? attrs}) => {
  "type": type,
  "content": content,
  "attrs": ?attrs,
};

/// Returns the JSON of a paragraph holding [content].
Map<String, dynamic> paragraphJson(List<Map<String, dynamic>> content) => containerJson("paragraph", content);

/// Builds a [StoryblokRichText] from the JSON of its [containers], forwarding the callbacks.
StoryblokRichText buildSubject(
  List<Map<String, dynamic>> containers, {
  void Function(fields.Link)? onTapLink,
  TextStyle Function(fields.RichTextLeafMarkable)? textStyleOverrides,
}) => StoryblokRichText(
  content: containers.map(fields.RichTextContainer.fromJson).toList(),
  onTapLink: onTapLink,
  blockBuilder: (context, data) => Text("blok ${data["component"]}", textDirection: TextDirection.ltr),
  textStyleOverrides: textStyleOverrides,
);

/// Wraps [child] in a Material app using [theme], with a [Scaffold] as the nearest Material ancestor.
Widget inScaffold(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme,
  home: Scaffold(body: child),
);

/// Returns the root span of the rendered rich text whose plain text is [text].
TextSpan rootSpan(WidgetTester tester, String text) =>
    tester.widget<RichText>(find.text(text, findRichText: true)).text as TextSpan;

/// Returns the first child span of the rendered rich text whose plain text is [text].
TextSpan leafSpan(WidgetTester tester, String text) => rootSpan(tester, text).children!.first as TextSpan;

/// Returns the `bodyMedium` style of the Material theme surrounding the subject.
TextStyle bodyMedium(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(StoryblokRichText))).textTheme.bodyMedium!;

/// Returns the WCAG contrast ratio between [a] and [b], from 1 to 21.
double contrast(Color a, Color b) {
  final luminances = [a.computeLuminance(), b.computeLuminance()]..sort();
  return (luminances.last + 0.05) / (luminances.first + 0.05);
}

/// Returns the colour the first leaf of the rich text [text] is painted with, falling back to the base style.
Color leafColor(WidgetTester tester, String text) =>
    leafSpan(tester, text).style?.color ?? rootSpan(tester, text).style!.color!;

void main() {
  group('Test base style inside a Scaffold', () {
    final themes = {
      'light Material 3': ThemeData.light(),
      'dark Material 3': ThemeData.dark(),
      'light Material 2': ThemeData(useMaterial3: false),
      'custom bodyMedium': ThemeData(
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 31, color: Color(0xFF123456))),
      ),
    };
    for (final MapEntry(key: name, value: theme) in themes.entries) {
      testWidgets('Test paragraph matches bodyMedium, $name', (tester) async {
        await tester.pumpWidget(
          inScaffold(
            theme: theme,
            buildSubject([
              paragraphJson([textJson("Hello")]),
            ]),
          ),
        );
        expect(rootSpan(tester, "Hello").style, bodyMedium(tester));
      });

      testWidgets('Test headings match bodyMedium with heading overrides, $name', (tester) async {
        await tester.pumpWidget(
          inScaffold(
            theme: theme,
            buildSubject([
              for (var level = 1; level <= 6; level++)
                containerJson("heading", [textJson("H$level")], attrs: {"level": level}),
            ]),
          ),
        );
        const fontSizes = {1: 24.0, 2: 24.0, 3: 24.0, 4: 24.0, 5: 19.2, 6: 16.0};
        for (final MapEntry(key: level, value: fontSize) in fontSizes.entries) {
          expect(
            rootSpan(tester, "H$level").style,
            bodyMedium(tester).copyWith(fontSize: fontSize, fontWeight: FontWeight.bold, letterSpacing: -1),
          );
        }
      });
    }
  });

  group('Test base style follows DefaultTextStyle', () {
    testWidgets('Test without any Material ancestor', (tester) async {
      const style = TextStyle(fontSize: 17, color: Color(0xFF00FF00));
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: DefaultTextStyle(
            style: style,
            child: buildSubject([
              paragraphJson([textJson("Hello")]),
            ]),
          ),
        ),
      );
      expect(rootSpan(tester, "Hello").style, style);
    });

    testWidgets('Test nearest DefaultTextStyle wins over the theme', (tester) async {
      const style = TextStyle(inherit: false, fontSize: 17, color: Color(0xFF00FF00));
      await tester.pumpWidget(
        inScaffold(
          DefaultTextStyle(
            style: style,
            child: buildSubject([
              paragraphJson([textJson("Hello")]),
            ]),
          ),
        ),
      );
      expect(rootSpan(tester, "Hello").style, style);
    });
  });

  group('Test marks', () {
    /// Pumps a paragraph with one leaf carrying [marks] and returns the style of that leaf.
    Future<TextStyle> pumpMarks(WidgetTester tester, List<Map<String, dynamic>> marks) async {
      await tester.pumpWidget(
        inScaffold(
          buildSubject([
            paragraphJson([textJson("Hello", marks)]),
          ]),
        ),
      );
      return leafSpan(tester, "Hello").style!;
    }

    testWidgets('Test bold, italic, strike and underline', (tester) async {
      final style = await pumpMarks(tester, [
        {"type": "bold"},
        {"type": "italic"},
        {"type": "strike"},
        {"type": "underline"},
      ]);
      expect(style.fontWeight, FontWeight.bold);
      expect(style.fontStyle, FontStyle.italic);
      expect(style.decoration, TextDecoration.combine([TextDecoration.lineThrough, TextDecoration.underline]));
    });

    testWidgets('Test code', (tester) async {
      final style = await pumpMarks(tester, [
        {"type": "code"},
      ]);
      expect(style.fontStyle, FontStyle.italic);
      expect(style.backgroundColor, isSameColorAs(Colors.grey));
    });

    testWidgets('Test text and highlight colors', (tester) async {
      final style = await pumpMarks(tester, [
        {
          "type": "textStyle",
          "attrs": {"color": "#FF8800"},
        },
        {
          "type": "highlight",
          "attrs": {"color": "rgb(0, 136, 255)"},
        },
      ]);
      expect(style.color, isSameColorAs(const Color(0xFFFF8800)));
      expect(style.backgroundColor, isSameColorAs(const Color(0xFF0088FF)));
    });

    testWidgets('Test superscript and subscript', (tester) async {
      expect(
        (await pumpMarks(tester, [
          {"type": "superscript"},
        ])).fontFeatures,
        const [FontFeature.superscripts()],
      );
      expect(
        (await pumpMarks(tester, [
          {"type": "subscript"},
        ])).fontFeatures,
        const [FontFeature.subscripts()],
      );
    });
  });

  group('Test links', () {
    final linkParagraph = paragraphJson([
      textJson("Hello", [
        {
          "type": "link",
          "attrs": {"linktype": "url", "href": "https://example.com/"},
        },
      ]),
    ]);

    testWidgets('Test style and tap', (tester) async {
      final tapped = <fields.Link>[];
      await tester.pumpWidget(inScaffold(buildSubject([linkParagraph], onTapLink: tapped.add)));
      final style = leafSpan(tester, "Hello").style!;
      expect(style.color, isNull);
      expect(style.decorationColor, isNull);
      expect(style.decoration, TextDecoration.combine([TextDecoration.underline]));

      await tester.tapOnText(find.textRange.ofSubstring("Hello"));
      expect((tapped.single as fields.LinkURL).url, Uri.parse("https://example.com/"));
    });

    testWidgets('Test no recognizer without onTapLink', (tester) async {
      await tester.pumpWidget(inScaffold(buildSubject([linkParagraph])));
      expect(leafSpan(tester, "Hello").recognizer, isNull);
    });

    testWidgets('Test no recognizer on plain text', (tester) async {
      await tester.pumpWidget(
        inScaffold(
          buildSubject(
            [
              paragraphJson([textJson("Hello")]),
            ],
            onTapLink: (_) {},
          ),
        ),
      );
      expect(leafSpan(tester, "Hello").recognizer, isNull);
    });
  });

  testWidgets('Test textStyleOverrides wins over marks', (tester) async {
    await tester.pumpWidget(
      inScaffold(
        buildSubject(
          [
            paragraphJson([
              textJson("Hello", [
                {"type": "bold"},
              ]),
            ]),
          ],
          textStyleOverrides: (leaf) => TextStyle(fontWeight: leaf.isBold ? FontWeight.w300 : null),
        ),
      ),
    );
    expect(leafSpan(tester, "Hello").style!.fontWeight, FontWeight.w300);
  });

  group('Test containers', () {
    testWidgets('Test code block', (tester) async {
      await tester.pumpWidget(
        inScaffold(
          buildSubject([
            containerJson("code_block", [textJson("code")], attrs: {"class": "language-dart"}),
          ]),
        ),
      );
      final box = tester.widget<Container>(
        find.ancestor(of: find.text("code", findRichText: true), matching: find.byType(Container)).first,
      );
      final decoration = box.decoration! as BoxDecoration;
      expect((decoration.border! as Border).top.color, isSameColorAs(Colors.grey));
      expect(decoration.color, isSameColorAs(const Color(0xFFEEEEEE)));
    });

    testWidgets('Test quote and line', (tester) async {
      await tester.pumpWidget(
        inScaffold(
          buildSubject([
            containerJson("blockquote", [
              paragraphJson([textJson("quote")]),
            ]),
            {"type": "horizontal_rule"},
          ]),
        ),
      );
      expect(find.text("quote", findRichText: true), findsOneWidget);
      final colors = tester.widgetList<Container>(find.byType(Container)).map((e) => e.color).toList();
      expect(colors, [isSameColorAs(Colors.grey), isSameColorAs(bodyMedium(tester).color!)]);
    });

    testWidgets('Test lists', (tester) async {
      final items = [
        containerJson("list_item", [
          paragraphJson([textJson("first")]),
        ]),
        containerJson("list_item", [
          paragraphJson([textJson("second")]),
        ]),
      ];
      await tester.pumpWidget(
        inScaffold(buildSubject([containerJson("bullet_list", items), containerJson("ordered_list", items)])),
      );
      expect(find.text("- "), findsNWidgets(2));
      expect(find.text("1. "), findsOneWidget);
      expect(find.text("2. "), findsOneWidget);
      expect(find.text("second", findRichText: true), findsNWidgets(2));
    });

    testWidgets('Test hard break and emoji', (tester) async {
      await tester.pumpWidget(
        inScaffold(
          buildSubject([
            paragraphJson([
              textJson("a"),
              {"type": "hard_break"},
              {
                "type": "emoji",
                "attrs": {"name": "smile", "emoji": "😄"},
              },
            ]),
          ]),
        ),
      );
      expect(find.text("a\n😄", findRichText: true), findsOneWidget);
    });

    testWidgets('Test blok uses blockBuilder', (tester) async {
      await tester.pumpWidget(
        inScaffold(
          buildSubject([
            {
              "type": "blok",
              "attrs": {
                "body": <Map<String, dynamic>>[
                  {"component": "hero"},
                ],
              },
            },
          ]),
        ),
      );
      expect(find.text("blok hero"), findsOneWidget);
    });
  });

  group('Test base style in other Material slots', () {
    final slots = <String, Widget Function(Widget child)>{
      'AppBar title': (child) => Scaffold(appBar: AppBar(title: child)),
      'ListTile title': (child) => Scaffold(body: ListTile(title: child)),
      'AlertDialog title': (child) => AlertDialog(title: child),
    };
    for (final MapEntry(key: name, value: slot) in slots.entries) {
      testWidgets('Test $name styles rich text like a Text', (tester) async {
        await tester.pumpWidget(MaterialApp(home: slot(const Text("Hello"))));
        final textStyle = rootSpan(tester, "Hello").style;

        await tester.pumpWidget(
          MaterialApp(
            home: slot(
              buildSubject([
                paragraphJson([textJson("Hello")]),
              ]),
            ),
          ),
        );
        expect(rootSpan(tester, "Hello").style, textStyle);
        expect(rootSpan(tester, "Hello").style!.fontSize, isNot(bodyMedium(tester).fontSize));
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Test MaterialApp without a Material ancestor', () {
    testWidgets('Test fallback style is inherited and headings are smaller than body', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: buildSubject([
            paragraphJson([textJson("Hello")]),
            containerJson("heading", [textJson("H1")], attrs: {"level": 1}),
          ]),
        ),
      );
      final style = rootSpan(tester, "Hello").style!;
      expect(style.color, isSameColorAs(const Color(0xD0FF0000)));
      expect(style.fontFamily, "monospace");
      expect(style.fontSize, 48);
      expect(style.decoration, TextDecoration.underline);
      expect(style.decorationStyle, TextDecorationStyle.double);
      expect(style.decorationColor, isSameColorAs(const Color(0xFFFFFF00)));
      expect(rootSpan(tester, "H1").style!.fontSize, 24);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Test leaves without marks remove the fallback underline', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: buildSubject([
            paragraphJson([textJson("Hello")]),
          ]),
        ),
      );
      expect(leafSpan(tester, "Hello").style!.decoration, TextDecoration.none);
    });
  });

  group('Test contrast', () {
    const textRatio = 4.5;
    const graphicRatio = 3.0;
    for (final (name, theme) in [('light', ThemeData.light()), ('dark', ThemeData.dark())]) {
      testWidgets('Test link is readable, $name', (tester) async {
        await tester.pumpWidget(
          inScaffold(
            theme: theme,
            buildSubject([
              paragraphJson([
                textJson("Hello", [
                  {
                    "type": "link",
                    "attrs": {"linktype": "url", "href": "https://example.com/"},
                  },
                ]),
              ]),
            ]),
          ),
        );
        final background = theme.scaffoldBackgroundColor;
        expect(contrast(leafColor(tester, "Hello"), background), greaterThanOrEqualTo(textRatio));
        expect(
          contrast(leafSpan(tester, "Hello").style!.decorationColor ?? leafColor(tester, "Hello"), background),
          greaterThanOrEqualTo(graphicRatio),
        );
      });

      testWidgets('Test horizontal rule is visible, $name', (tester) async {
        await tester.pumpWidget(
          inScaffold(
            theme: theme,
            buildSubject([
              {"type": "horizontal_rule"},
            ]),
          ),
        );
        final color = tester.widget<Container>(find.byType(Container)).color!;
        expect(contrast(color, theme.scaffoldBackgroundColor), greaterThanOrEqualTo(graphicRatio));
      });

      testWidgets('Test code block is readable, $name', (tester) async {
        await tester.pumpWidget(
          inScaffold(
            theme: theme,
            buildSubject([
              containerJson("code_block", [textJson("code")], attrs: {"class": "language-dart"}),
            ]),
          ),
        );
        final box = tester.widget<Container>(find.byType(Container));
        final background = (box.decoration! as BoxDecoration).color!;
        expect(contrast(leafColor(tester, "code"), background), greaterThanOrEqualTo(textRatio));
      });

      testWidgets('Test inline code is readable, $name', (tester) async {
        await tester.pumpWidget(
          inScaffold(
            theme: theme,
            buildSubject([
              paragraphJson([
                textJson("code", [
                  {"type": "code"},
                ]),
              ]),
            ]),
          ),
        );
        final background = leafSpan(tester, "code").style!.backgroundColor!;
        expect(contrast(leafColor(tester, "code"), background), greaterThanOrEqualTo(textRatio));
      });
    }
  });

  testWidgets(
    'Test AlertDialog content shrinks to fit',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AlertDialog(
            content: buildSubject([
              paragraphJson([textJson("Hello")]),
            ]),
          ),
        ),
      );
      final dialog = find.descendant(of: find.byType(AlertDialog), matching: find.byType(Material)).first;
      final height = tester.getSize(dialog).height;
      expect(
        height,
        lessThan(tester.view.physicalSize.height / tester.view.devicePixelRatio / 2),
      );
    },
  );
}
