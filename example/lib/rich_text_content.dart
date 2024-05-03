import 'dart:math';

import 'package:example/bloks.generated.dart';
import 'package:example/components/colors.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/rich_text.dart' as rich_blok;
import 'package:flutter_storyblok/utils.dart';

class StoryblokRichTextContent extends StatelessWidget {
  const StoryblokRichTextContent({super.key, required this.content});
  final List<rich_blok.RichTextComponent> content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: content
          .map((e) => e.buildComponentWidget(context)) //
          .separatedBy(() => const SizedBox(height: 16))
          .toList(),
    );
  }
}

// MARK: - Components

extension _RichTextComponentBuildWidget on rich_blok.RichTextComponent {
  Widget buildComponentWidget(BuildContext context) {
    return switch (this) {
      final rich_blok.RichTextComponentParagraph paragraph => paragraph.content.buildRichText(context),
      final rich_blok.RichTextComponentHeading heading => heading.content.buildRichText(
          context,
          textStyle: TextStyle(
            fontSize: 24 / max(1, (heading.level / 4)),
            fontWeight: FontWeight.bold,
          ),
        ),
      final rich_blok.RichTextComponentCode code => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
            color: const Color(0xFFEEEEEE),
          ),
          child: code.content.buildRichText(context),
        ),
      final rich_blok.RichTextComponentQuote quote => IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: 4, color: Colors.grey),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: quote.content.buildRichText(context),
                ),
              )
            ],
          ),
        ),
      final rich_blok.RichTextComponentLine _ => Container(height: 1, color: Colors.black),
      final rich_blok.RichTextComponentList list => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: list.rows
              .mapIndexed((i, e) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list.isOrdered ? "${i + 1}. " : "- "),
                      Expanded(child: e.content.buildRichText(context)),
                    ],
                  ))
              .toList(),
        ),
      final rich_blok.RichTextComponentBlok blok => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: blok.bloksData.map((e) => Blok.fromJson(e).buildWidget(context)).toList(),
        ),
      _ => RichText(text: const TextSpan()),
    };
  }
}

// MARK: - Leaves

extension _RichTextLeafBuildWidget on List<rich_blok.RichTextLeaf> {
  Widget buildRichText(BuildContext context, {TextStyle? textStyle}) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.merge(textStyle),
        children: map((e) => switch (e) {
              final rich_blok.RichTextLeafText text => _buildLeafText(context, text),
              final rich_blok.RichTextLeafEmoji emoji => TextSpan(text: emoji.text ?? "⌧"),
              final rich_blok.RichTextLeafImage image => WidgetSpan(child: Image.network(image.imageUrl.toString())),
              final rich_blok.RichTextLeafHardBreak _ => const TextSpan(text: "\n"),
              final rich_blok.RichTextComponentParagraph paragraph => WidgetSpan(
                  child: paragraph.buildComponentWidget(context),
                ),
              rich_blok.UnrecognizedRichTextLeaf() => const TextSpan(),
            }).toList(),
      ),
    );
  }
}

// MARK: - Text

TextSpan _buildLeafText(BuildContext context, rich_blok.RichTextLeafText text) {
  final foregroundColor =
      mapIfNotNull(text.foregroundColor?.colorHex, _HexColor.new) ?? (text.link != null ? AppColors.accent : null);
  final link = text.link;
  return TextSpan(
    text: text.text,
    recognizer: link == null ? null : (TapGestureRecognizer()..onTap = () => print("Tap ${link.link}")),
    style: TextStyle(
      backgroundColor: text.isCode ? Colors.grey : mapIfNotNull(text.backgroundColor?.colorHex, _HexColor.new),
      color: foregroundColor,
      fontStyle: text.isItalic || text.isCode ? FontStyle.italic : null,
      fontWeight: text.isBold ? FontWeight.bold : null,
      decorationColor: text.link == null ? foregroundColor : AppColors.accent,
      decorationStyle: TextDecorationStyle.solid,
      decoration: TextDecoration.combine([
        if (text.isStriked) TextDecoration.lineThrough,
        if (text.isUnderlined || text.link != null) TextDecoration.underline,
      ]),
      fontFeatures: [
        if (text.isSuperscript) const FontFeature.superscripts(),
        if (text.isSubscript) const FontFeature.subscripts(),
      ],
    ),
  );
}

// MARK: - HexColor

class _HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  _HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
