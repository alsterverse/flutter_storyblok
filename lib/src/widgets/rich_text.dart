import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as sb;
import 'package:flutter_storyblok/src/fields/link.dart';
import 'package:flutter_storyblok/src/fields/rich_text.dart';
import 'package:flutter_storyblok/src/utils.dart';
import 'package:flutter_storyblok/src/widgets/hex_color.dart';

typedef BlockBuilder = Widget Function(BuildContext context, JSONMap data);

/// Storyblok RichText to Flutter RichText bridge
final class StoryblokRichText extends StatelessWidget {
  StoryblokRichText({
    super.key,
    required this.content,
    void Function(Link)? onTapLink,
    required BlockBuilder blockBuilder,
    this.textAlign = TextAlign.start,
    TextStyle Function(RichTextLeafMarkable)? textStyleOverrides,
  }) : _contentData = _StoryblokRichTextContentData(
          onTapLink: onTapLink,
          buildBlok: blockBuilder,
          textStyleOverrides: textStyleOverrides,
        );

  final _StoryblokRichTextContentData _contentData;
  final List<RichTextContainer> content;
  final TextAlign textAlign;

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

/// Used for passing data to the containers and leaves
final class _StoryblokRichTextContentData {
  _StoryblokRichTextContentData({
    required this.onTapLink,
    required this.buildBlok,
    this.textStyleOverrides,
  });
  final void Function(Link)? onTapLink;
  final BlockBuilder buildBlok;
  final TextStyle Function(RichTextLeafMarkable)? textStyleOverrides;
}

// MARK: - Containers

extension _RichTextContainerWidget on RichTextContainer {
  Widget buildContainerWidget(BuildContext context, _StoryblokRichTextContentData contentData) {
    return switch (this) {
      final RichTextContainerParagraph paragraph => paragraph.content.buildRichText(context, contentData),
      final RichTextContainerHeading heading => heading.content.buildRichText(
          context,
          contentData,
          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 24 / max(1, (heading.level / 4)),
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
        ),
      final RichTextContainerCode code => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
            color: const Color(0xFFEEEEEE),
          ),
          child: code.content.buildRichText(context, contentData),
        ),
      final RichTextContainerQuote quote => IntrinsicHeight(
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
      final RichTextContainerLine _ => Container(height: 1, color: Colors.black),
      final RichTextContainerList list => Column(
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
      final RichTextContainerBlok blok => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: blok.bloksData.map((e) => contentData.buildBlok(context, e)).toList(),
        ),
      _ => sb.RichText(text: const TextSpan()),
    };
  }
}

// MARK: - Leaves

extension _RichTextLeafBuildWidget on List<RichTextLeaf> {
  Widget buildRichText(
    BuildContext context,
    _StoryblokRichTextContentData contentData, {
    TextStyle? textStyle,
  }) {
    return sb.RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium?.merge(textStyle),
        children: map((e) => switch (e) {
              final RichTextLeafText text => text.buildTextSpan(text.text, contentData),
              final RichTextLeafEmoji emoji => emoji.buildTextSpan(emoji.text ?? "⌧", contentData),
              final RichTextLeafImage image => WidgetSpan(
                  style: image.buildTextStyle(),
                  child: Image(image: NetworkImage(image.imageUrl.toString())),
                ),
              final RichTextLeafHardBreak _ => const TextSpan(text: "\n"),
              final RichTextContainerParagraph paragraph => WidgetSpan(
                  child: paragraph.buildContainerWidget(context, contentData),
                ),
              UnrecognizedRichTextLeaf() => const WidgetSpan(child: SizedBox.shrink()),
            }).toList(),
      ),
    );
  }
}

// MARK: - Markable TextStyle

extension _RichTextLeafMarkableWidget on RichTextLeafMarkable {
  TextStyle buildTextStyle() {
    final foregroundColor =
        mapIfNotNull(this.foregroundColor?.colorHex, HexColor.new) ?? (link != null ? Colors.black : null);
    return TextStyle(
      backgroundColor: isCode ? Colors.grey : mapIfNotNull(backgroundColor?.colorHex, HexColor.new),
      color: foregroundColor,
      fontStyle: isItalic || isCode ? FontStyle.italic : null,
      fontWeight: isBold ? FontWeight.bold : null,
      decorationColor: link == null ? foregroundColor : Colors.black,
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
      style: buildTextStyle().merge(contentData.textStyleOverrides?.call(this)),
    );
  }
}
