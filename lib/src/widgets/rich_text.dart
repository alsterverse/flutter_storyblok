import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as sb;
import 'package:flutter_storyblok/src/fields/link.dart';
import 'package:flutter_storyblok/src/fields/rich_text.dart';
import 'package:flutter_storyblok/src/utils.dart';
import 'package:flutter_storyblok/widgets.dart';

const _black = Color(0xFF000000);
const _grey = Color(0xFF9E9E9E);

typedef BlockBuilder = Widget Function(BuildContext context, JSONMap data);

typedef _RecognizerKey = (String text, Object link, int occurrence);

/// Storyblok RichText to Flutter RichText bridge
///
/// Text, links and horizontal rules inherit the ambient [DefaultTextStyle], which a Material ancestor such as a
/// `Scaffold` provides. Code uses dark text on its own light background.
final class StoryblokRichText extends StatefulWidget {
  StoryblokRichText({
    super.key,
    required this.content,
    void Function(Link)? onTapLink,
    required BlockBuilder blockBuilder,
    this.textAlign = TextAlign.start,
    TextStyle Function(RichTextLeafMarkable)? textStyleOverrides,
  }) : _onTapLink = onTapLink,
       _blockBuilder = blockBuilder,
       _textStyleOverrides = textStyleOverrides;

  final void Function(Link)? _onTapLink;
  final BlockBuilder _blockBuilder;
  final TextStyle Function(RichTextLeafMarkable)? _textStyleOverrides;
  final List<RichTextContainer> content;
  final TextAlign textAlign;

  @override
  State<StoryblokRichText> createState() => _StoryblokRichTextState();
}

final class _StoryblokRichTextState extends State<StoryblokRichText> {
  final _recognizers = <_RecognizerKey, TapGestureRecognizer>{};

  @override
  void dispose() {
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    super.dispose();
  }

  /// Builds [content] as a column that is only as tall as its children.
  @override
  Widget build(BuildContext context) {
    final contentData = _StoryblokRichTextContentData(
      onTapLink: widget._onTapLink,
      buildBlok: widget._blockBuilder,
      textStyleOverrides: widget._textStyleOverrides,
      recognizers: _recognizers,
    );
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widget.content
          .map((e) => e.buildContainerWidget(context, contentData)) //
          .separatedBy(() => const SizedBox(height: 16))
          .toList(),
    );
    // Recognizers are kept across rebuilds, even of re-parsed content, so a tap in progress survives; only those whose
    // text and link are gone from this build are disposed.
    _recognizers.removeWhere((key, recognizer) {
      if (contentData.usedRecognizerKeys.contains(key)) return false;
      recognizer.dispose();
      return true;
    });
    return column;
  }
}

// MARK: - Data

/// Used for passing data to the containers and leaves
final class _StoryblokRichTextContentData {
  _StoryblokRichTextContentData({
    required this.onTapLink,
    required this.buildBlok,
    this.textStyleOverrides,
    required this.recognizers,
  });
  final void Function(Link)? onTapLink;
  final BlockBuilder buildBlok;
  final TextStyle Function(RichTextLeafMarkable)? textStyleOverrides;

  final Map<_RecognizerKey, TapGestureRecognizer> recognizers;
  final usedRecognizerKeys = <_RecognizerKey>{};
  final _occurrences = <(String, Object), int>{};

  TapGestureRecognizer tapRecognizer(String text, Link link, VoidCallback onTap) {
    final linkKey = _linkKey(link);
    final occurrence = _occurrences.update((text, linkKey), (count) => count + 1, ifAbsent: () => 0);
    final key = (text, linkKey, occurrence);
    usedRecognizerKeys.add(key);
    return (recognizers[key] ??= TapGestureRecognizer())..onTap = onTap;
  }
}

/// Returns a value that is equal for links to the same target, as [Link] does not define equality.
Object _linkKey(Link link) => switch (link) {
  LinkURL(:final url) => (LinkURL, url),
  LinkAsset(:final url) => (LinkAsset, url),
  LinkEmail(:final email) => (LinkEmail, email),
  LinkStory(:final uuid, :final anchor) => (LinkStory, uuid, anchor),
};

// MARK: - Containers

extension _RichTextContainerWidget on RichTextContainer {
  /// Builds the widget for this container, using [contentData] for link, blok and style callbacks.
  Widget buildContainerWidget(BuildContext context, _StoryblokRichTextContentData contentData) {
    return switch (this) {
      final RichTextContainerParagraph paragraph => paragraph.content.buildRichText(context, contentData),
      final RichTextContainerHeading heading => heading.content.buildRichText(
        context,
        contentData,
        textStyle: TextStyle(
          fontSize: 24 / max(1, (heading.level / 4)),
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
        ),
      ),
      final RichTextContainerCode code => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _grey),
          color: const Color(0xFFEEEEEE),
        ),
        child: code.content.buildRichText(context, contentData, textStyle: const TextStyle(color: _black)),
      ),
      final RichTextContainerQuote quote => IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(width: 4, color: _grey),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: quote.content.buildRichText(context, contentData),
              ),
            ),
          ],
        ),
      ),
      final RichTextContainerLine _ => Container(
        height: 1,
        color: DefaultTextStyle.of(context).style.color ?? _black,
      ),
      final RichTextContainerList list => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: list.rows
            .mapIndexed(
              (i, e) => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(list.isOrdered ? "${i + 1}. " : "- "),
                  Expanded(child: e.content.buildRichText(context, contentData)),
                ],
              ),
            )
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
  /// Builds these leaves as one [sb.RichText], merging [textStyle] onto the ambient [DefaultTextStyle] of [context].
  Widget buildRichText(
    BuildContext context,
    _StoryblokRichTextContentData contentData, {
    TextStyle? textStyle,
  }) {
    return sb.RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.merge(textStyle),
        children: map(
          (e) => switch (e) {
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
          },
        ).toList(),
      ),
    );
  }
}

// MARK: - Markable TextStyle

extension _RichTextLeafMarkableWidget on RichTextLeafMarkable {
  /// Returns the [TextStyle] described by the marks on this leaf.
  TextStyle buildTextStyle() {
    final foregroundColor = this.foregroundColor?.color ?? (isCode ? _black : null);
    return TextStyle(
      backgroundColor: isCode ? _grey : backgroundColor?.color,
      color: foregroundColor,
      fontStyle: isItalic || isCode ? FontStyle.italic : null,
      fontWeight: isBold ? FontWeight.bold : null,
      decorationColor: foregroundColor,
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
          (link) => contentData.tapRecognizer(text, link, () => onTapLink(link)),
        ),
      ),
      style: buildTextStyle().merge(contentData.textStyleOverrides?.call(this)),
    );
  }
}
