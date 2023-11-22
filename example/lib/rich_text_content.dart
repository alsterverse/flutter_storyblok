import 'dart:math';

import 'package:example/bloks.generated.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storyblok/rich_text.dart';
import 'package:flutter_storyblok/utils.dart';

class StoryblokRichTextContent extends StatelessWidget {
  const StoryblokRichTextContent({super.key, required this.content});
  final List<RichTextComponent> content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: content
          .map(
            (e) => e.buildComponentWidget(context),
          )
          .separatedBy(() => const SizedBox(height: 16))
          .toList(),
    );
  }
}

extension RichTextComponentWidget on RichTextComponent {
  Widget buildComponentWidget(BuildContext context) {
    return switch (this) {
      final RichTextComponentParagraph paragraph => Wrap(
          children: paragraph.content.map((e) => e.buildLeafWidget(context)).toList(),
        ),
      final RichTextComponentHeading heading => DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: 24 / max(1, (heading.level / 4)),
            fontWeight: FontWeight.bold,
          ),
          child: Wrap(
            children: heading.content.map((e) => e.buildLeafWidget(context)).toList(),
          ),
        ),
      final RichTextComponentCode code => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
            color: const Color(0xFFEEEEEE),
          ),
          child: Wrap(
            children: code.content.map((e) => e.buildLeafWidget(context)).toList(),
          ),
        ),
      final RichTextComponentQuote quote => IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: 4, color: Colors.grey),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: quote.content.map((e) => e.buildLeafWidget(context)).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      RichTextComponentLine() => Container(height: 1, color: Colors.black),
      final RichTextComponentList list => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: list.rows
              .mapIndexed((i, e) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list.isOrdered ? "${i + 1}. " : "- "),
                      Expanded(
                        child: Wrap(
                          children: e.content.map((e) => e.buildLeafWidget(context)).toList(),
                        ),
                      )
                    ],
                  ))
              .toList(),
        ),
      final RichTextComponentBlok blok => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: blok.bloksData.map((e) => Blok.fromJson(e).buildWidget(context)).toList(),
        ),
      UnrecognizedRichTextComponent() => const SizedBox.shrink(),
    };
  }
}

extension RichTextLeaftWidget on RichTextLeaf {
  Widget buildLeafWidget(BuildContext context) {
    return switch (this) {
      final RichTextLeafText text => RichTextLeafTextWidget(text: text),
      final RichTextLeafImage image => Image.network(image.imageUrl.toString()),
      final RichTextLeafHardBreak _ => const SizedBox(width: double.infinity),
      final RichTextComponentParagraph paragraph => paragraph.buildComponentWidget(context),
      UnrecognizedRichTextLeaf() => const SizedBox.shrink()
    };
  }
}

class RichTextLeafTextWidget extends StatelessWidget {
  const RichTextLeafTextWidget({super.key, required this.text});
  final RichTextLeafText text;

  @override
  Widget build(BuildContext context) {
    final string = text.text.replaceAll(" ", " ");
    if (text.isSuperscript || text.isSubscript) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: text.isSuperscript ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          SizedBox(width: 0, child: _buildText(context, "")),
          _buildText(context, string, true),
        ],
      );
    }
    return _buildText(context, string);
  }

  Text _buildText(BuildContext context, String string, [bool subOrSuperscript = false]) {
    final foregroundColor = mapIfNotNull(text.foregroundColor, HexColor.new);

    return Text(
      string,
      style: TextStyle(
        backgroundColor: text.isCode ? Colors.grey : mapIfNotNull(text.backgroundColor, HexColor.new),
        color: foregroundColor,
        fontSize: mapIfNotNull(
          DefaultTextStyle.of(context).style.fontSize,
          (size) => subOrSuperscript ? size * 0.7 : size,
        ),
        fontStyle: text.isItalic || text.isCode ? FontStyle.italic : null,
        fontWeight: text.isBold ? FontWeight.bold : null,
        decorationColor: foregroundColor,
        decorationStyle: TextDecorationStyle.solid,
        decoration: TextDecoration.combine([
          if (text.isStriked) TextDecoration.lineThrough,
          if (text.isUnderlined) TextDecoration.underline,
        ]),
      ),
    );
  }
}

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
