import 'dart:math';

import 'package:example/bloks.generated.dart';
import 'package:example/components/colors.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/link.dart';
import 'package:flutter_storyblok/rich_text.dart' as rich_blok;
import 'package:flutter_storyblok/utils.dart';

// TODO: library...ify this code

class StoryblokRichTextContent extends StatelessWidget {
  StoryblokRichTextContent({
    super.key,
    required this.content,
    void Function(Link)? onTapLink,
  }) : _contentData = _StoryblokRichTextContentData(onTapLink: onTapLink);

  final _StoryblokRichTextContentData _contentData;
  final List<rich_blok.RichTextContainer> content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: content
          .map((e) => e.buildContainerWidget(context, _contentData)) //
          .separatedBy(() => const SizedBox(height: 16))
          .toList(),
    );
  }
}

// MARK: - Data

// library...ify
/// Used for passing data to the containers and leaves
class _StoryblokRichTextContentData {
  _StoryblokRichTextContentData({required this.onTapLink});
  final void Function(Link)? onTapLink;
}

// MARK: - Containers

extension _RichTextContainerWidget on rich_blok.RichTextContainer {
  Widget buildContainerWidget(BuildContext context, _StoryblokRichTextContentData contentData) {
    return switch (this) {
      final rich_blok.RichTextContainerParagraph paragraph => paragraph.content.buildRichText(context, contentData),
      final rich_blok.RichTextContainerHeading heading => heading.content.buildRichText(
          context,
          contentData,
          textStyle: TextStyle(
            fontSize: 24 / max(1, (heading.level / 4)),
            fontWeight: FontWeight.bold,
          ),
        ),
      final rich_blok.RichTextContainerCode code => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
            color: const Color(0xFFEEEEEE),
          ),
          child: code.content.buildRichText(context, contentData),
        ),
      final rich_blok.RichTextContainerQuote quote => IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: 4, color: Colors.grey),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: quote.content.buildRichText(context, contentData),
                ),
              )
            ],
          ),
        ),
      final rich_blok.RichTextContainerLine _ => Container(height: 1, color: Colors.black),
      final rich_blok.RichTextContainerList list => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: list.rows
              .mapIndexed((i, e) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list.isOrdered ? "${i + 1}. " : "- "),
                      Expanded(child: e.content.buildRichText(context, contentData)),
                    ],
                  ))
              .toList(),
        ),
      final rich_blok.RichTextContainerBlok blok => Column(
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
  Widget buildRichText(
    BuildContext context,
    _StoryblokRichTextContentData contentData, {
    TextStyle? textStyle,
  }) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.merge(textStyle),
        children: map((e) => switch (e) {
              final rich_blok.RichTextLeafText text => text.buildTextSpan(text.text, contentData),
              final rich_blok.RichTextLeafEmoji emoji => emoji.buildTextSpan(emoji.text ?? "⌧", contentData),
              final rich_blok.RichTextLeafImage image => WidgetSpan(
                  style: image.buildTextStyle(),
                  child: Image.network(image.imageUrl.toString()),
                ),
              final rich_blok.RichTextLeafHardBreak _ => const TextSpan(text: "\n"),
              final rich_blok.RichTextContainerParagraph paragraph => WidgetSpan(
                  child: paragraph.buildContainerWidget(context, contentData),
                ),
              rich_blok.UnrecognizedRichTextLeaf() => const WidgetSpan(child: SizedBox.shrink()),
            }).toList(),
      ),
    );
  }
}

// MARK: - Markable TextStyle

extension _RichTextLeafMarkableWidget on rich_blok.RichTextLeafMarkable {
  TextStyle buildTextStyle() {
    final foregroundColor =
        mapIfNotNull(this.foregroundColor?.colorHex, _HexColor.new) ?? (link != null ? AppColors.accent : null);
    return TextStyle(
      backgroundColor: isCode ? Colors.grey : mapIfNotNull(backgroundColor?.colorHex, _HexColor.new),
      color: foregroundColor,
      fontStyle: isItalic || isCode ? FontStyle.italic : null,
      fontWeight: isBold ? FontWeight.bold : null,
      decorationColor: link == null ? foregroundColor : AppColors.accent,
      decorationStyle: TextDecorationStyle.solid,
      decoration: TextDecoration.combine([
        if (isStriked) TextDecoration.lineThrough,
        if (isUnderlined || link != null) TextDecoration.underline,
      ]),
      fontFeatures: [
        if (isSuperscript) const FontFeature.superscripts(),
        if (isSubscript) const FontFeature.subscripts(),
      ],
    );
  }

  TextSpan buildTextSpan(String text, _StoryblokRichTextContentData contentData) {
    return TextSpan(
      text: text,
      recognizer: mapIfNotNull(
        contentData.onTapLink,
        (onTapLink) => mapIfNotNull(
          link?.link,
          (link) => TapGestureRecognizer()..onTap = () => onTapLink(link),
        ),
      ),
      style: buildTextStyle(),
    );
  }
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
