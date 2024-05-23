import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/bloks.generated.dart';
import 'package:example/components/colors.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart' as sb;
import 'package:collection/collection.dart';

// TODO: library...ify this code

class StoryblokRichTextContent extends StatelessWidget {
  StoryblokRichTextContent({
    super.key,
    required this.content,
    void Function(sb.Link)? onTapLink,
    this.textAlign = TextAlign.start,
  }) : _contentData = _StoryblokRichTextContentData(onTapLink: onTapLink);

  final _StoryblokRichTextContentData _contentData;
  final List<sb.RichTextContainer> content;
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

// library...ify
/// Used for passing data to the containers and leaves
class _StoryblokRichTextContentData {
  _StoryblokRichTextContentData({required this.onTapLink});
  final void Function(sb.Link)? onTapLink;
}

// MARK: - Containers

extension _RichTextContainerWidget on sb.RichTextContainer {
  Widget buildContainerWidget(BuildContext context, _StoryblokRichTextContentData contentData) {
    return switch (this) {
      final sb.RichTextContainerParagraph paragraph => paragraph.content.buildRichText(context, contentData),
      final sb.RichTextContainerHeading heading => heading.content.buildRichText(
          context,
          contentData,
          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 24 / max(1, (heading.level / 4)),
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
        ),
      final sb.RichTextContainerCode code => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey),
            color: const Color(0xFFEEEEEE),
          ),
          child: code.content.buildRichText(context, contentData),
        ),
      final sb.RichTextContainerQuote quote => IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: 4, color: AppColors.grey),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: quote.content.buildRichText(context, contentData),
                ),
              )
            ],
          ),
        ),
      final sb.RichTextContainerLine _ => Container(height: 1, color: AppColors.black),
      final sb.RichTextContainerList list => Column(
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
      final sb.RichTextContainerBlok blok => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: blok.bloksData.map((e) => Blok.fromJson(e).buildWidget(context)).toList(),
        ),
      _ => RichText(text: const TextSpan()),
    };
  }
}

// MARK: - Leaves

extension _RichTextLeafBuildWidget on List<sb.RichTextLeaf> {
  Widget buildRichText(
    BuildContext context,
    _StoryblokRichTextContentData contentData, {
    TextStyle? textStyle,
  }) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium?.merge(textStyle),
        children: map((e) => switch (e) {
              final sb.RichTextLeafText text => text.buildTextSpan(text.text, contentData),
              final sb.RichTextLeafEmoji emoji => emoji.buildTextSpan(emoji.text ?? "⌧", contentData),
              final sb.RichTextLeafImage image => WidgetSpan(
                  style: image.buildTextStyle(),
                  child: Image(image: CachedNetworkImageProvider(image.imageUrl.toString())),
                ),
              final sb.RichTextLeafHardBreak _ => const TextSpan(text: "\n"),
              final sb.RichTextContainerParagraph paragraph => WidgetSpan(
                  child: paragraph.buildContainerWidget(context, contentData),
                ),
              sb.UnrecognizedRichTextLeaf() => const WidgetSpan(child: SizedBox.shrink()),
            }).toList(),
      ),
    );
  }
}

// MARK: - Markable TextStyle

extension _RichTextLeafMarkableWidget on sb.RichTextLeafMarkable {
  TextStyle buildTextStyle() {
    final foregroundColor =
        mapIfNotNull(this.foregroundColor?.colorHex, HexColor.new) ?? (link != null ? AppColors.accent : null);
    return TextStyle(
      backgroundColor: isCode ? AppColors.grey : mapIfNotNull(backgroundColor?.colorHex, HexColor.new),
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

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
