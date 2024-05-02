//

import 'package:flutter_storyblok/link.dart';
import 'package:flutter_storyblok/utils.dart';

class RichText {
  String type;
  List<RichTextComponent> content;

  RichText({required this.type, required this.content});

  factory RichText.fromJson(Map<String, dynamic> json) {
    return RichText(
      type: json['type'],
      content: List<JSONMap>.from(json['content']).map(RichTextComponent.fromJson).toList(),
    );
  }
}

// MARK: - Leaf
//
//

sealed class RichTextLeaf {
  RichTextLeaf();
  factory RichTextLeaf.fromJson(JSONMap json) {
    final type = json["type"];
    return switch (type) {
      "text" => RichTextLeafText.fromJson(json),
      "emoji" => RichTextLeafEmoji.fromJson(json),
      "image" => RichTextLeafImage.fromJson(json),
      "hard_break" => RichTextLeafHardBreak(),
      "paragraph" => RichTextComponentParagraph.fromJson(json),
      _ => UnrecognizedRichTextLeaf(type, json),
    };
  }
}

class UnrecognizedRichTextLeaf extends RichTextLeaf {
  UnrecognizedRichTextLeaf(this.type, this.data) {
    print("Unrecognized rich-text leaf: $type");
  }
  final String type;
  final JSONMap data;
}

// MARK: - Leafs
//
//
//

// MARK: - Text mark

sealed class RichTextLeafTextMark {
  RichTextLeafTextMark();
  factory RichTextLeafTextMark.fromJson(JSONMap json) {
    final type = json["type"];
    return switch (type) {
      "bold" => RichTextLeafTextMarkBold(),
      "italic" => RichTextLeafTextMarkItalic(),
      "strike" => RichTextLeafTextMarkStrike(),
      "underline" => RichTextLeafTextMarkUnderline(),
      "superscript" => RichTextLeafTextMarkSuperscript(),
      "subscript" => RichTextLeafTextMarkSubscript(),
      "code" => RichTextLeafTextMarkCode(),
      "anchor" => RichTextLeafTextMarkAnchor.fromJson(json),
      "link" => RichTextLeafTextMarkLink.fromJson(json),
      "textStyle" => RichTextLeafTextMarkTextStyle.fromJson(json),
      "highlight" => RichTextLeafTextMarkHighlight.fromJson(json),
      _ => UnrecognizedTextRichTextMark(type, json),
    };
  }
}

class UnrecognizedTextRichTextMark extends RichTextLeafTextMark {
  UnrecognizedTextRichTextMark(this.type, this.data) {
    print("Unrecognized rich-text text mark: $type");
  }
  final String type;
  final JSONMap data;
}

// MARK: - Text marks
//

class RichTextLeafTextMarkBold extends RichTextLeafTextMark {}

class RichTextLeafTextMarkItalic extends RichTextLeafTextMark {}

class RichTextLeafTextMarkStrike extends RichTextLeafTextMark {}

class RichTextLeafTextMarkUnderline extends RichTextLeafTextMark {}

class RichTextLeafTextMarkSuperscript extends RichTextLeafTextMark {}

class RichTextLeafTextMarkSubscript extends RichTextLeafTextMark {}

class RichTextLeafTextMarkCode extends RichTextLeafTextMark {}

class RichTextLeafTextMarkAnchor extends RichTextLeafTextMark {
  RichTextLeafTextMarkAnchor({required this.id});
  factory RichTextLeafTextMarkAnchor.fromJson(JSONMap json) => RichTextLeafTextMarkAnchor(
        id: json["attrs"]["id"],
      );
  final String id;
}

class RichTextLeafTextMarkLink extends RichTextLeafTextMark {
  RichTextLeafTextMarkLink({required this.link});
  factory RichTextLeafTextMarkLink.fromJson(JSONMap json) => RichTextLeafTextMarkLink(
        link: Link.fromJson(json["attrs"]),
      );
  final Link? link;
}

class RichTextLeafTextMarkTextStyle extends RichTextLeafTextMark {
  RichTextLeafTextMarkTextStyle({required this.colorHex});
  factory RichTextLeafTextMarkTextStyle.fromJson(JSONMap json) => RichTextLeafTextMarkTextStyle(
        colorHex: json["attrs"]["color"],
      );
  final String colorHex;
}

class RichTextLeafTextMarkHighlight extends RichTextLeafTextMark {
  RichTextLeafTextMarkHighlight({required this.colorHex});
  factory RichTextLeafTextMarkHighlight.fromJson(JSONMap json) => RichTextLeafTextMarkHighlight(
        colorHex: json["attrs"]["color"],
      );
  final String colorHex;
}

// MARK: - Leafs
//
//

class RichTextLeafText extends RichTextLeaf {
  RichTextLeafText({required this.text, required List<RichTextLeafTextMark> marks})
      : isCode = marks.containsType<RichTextLeafTextMarkCode>(),
        isBold = marks.containsType<RichTextLeafTextMarkBold>(),
        isItalic = marks.containsType<RichTextLeafTextMarkItalic>(),
        isStriked = marks.containsType<RichTextLeafTextMarkStrike>(),
        isUnderlined = marks.containsType<RichTextLeafTextMarkUnderline>(),
        isSuperscript = marks.containsType<RichTextLeafTextMarkSuperscript>(),
        isSubscript = marks.containsType<RichTextLeafTextMarkSubscript>(),
        anchor = marks.firstAsType(),
        link = marks.firstAsType(),
        backgroundColor = marks.firstAsType(),
        foregroundColor = marks.firstAsType();

  factory RichTextLeafText.fromJson(JSONMap json) => RichTextLeafText(
        text: json["text"],
        marks: List<JSONMap>.from(json["marks"] ?? []).map(RichTextLeafTextMark.fromJson).toList(),
      );

  final String text;
  final bool isCode;
  final bool isBold;
  final bool isItalic;
  final bool isStriked;
  final bool isUnderlined;
  final bool isSuperscript;
  final bool isSubscript;
  final RichTextLeafTextMarkAnchor? anchor;
  final RichTextLeafTextMarkLink? link;
  final RichTextLeafTextMarkHighlight? backgroundColor;
  final RichTextLeafTextMarkTextStyle? foregroundColor;
}

class RichTextLeafEmoji extends RichTextLeaf {
  RichTextLeafEmoji({
    required this.name,
    required this.text,
    required this.fallback,
  });
  factory RichTextLeafEmoji.fromJson(JSONMap json) => RichTextLeafEmoji(
        name: json["attrs"]["name"],
        text: json["attrs"]["emoji"],
        fallback: mapIfNotNull(json["attrs"]["fallbackImage"] as String?, Uri.parse),
      );
  final String name;
  final String? text;
  final Uri? fallback;
}

class RichTextLeafImage extends RichTextLeaf {
  RichTextLeafImage({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.source,
    required this.alt,
    required this.copyright,
    required this.metadata,
  });
  factory RichTextLeafImage.fromJson(JSONMap json) {
    json = JSONMap.from(json["attrs"]);
    return RichTextLeafImage(
      id: json["id"],
      imageUrl: Uri.parse(json["src"]),
      title: json["title"],
      source: json["source"],
      alt: json["alt"],
      copyright: json["copyright"],
      metadata: JSONMap.from(json["meta_data"]),
    );
  }

  final int id;
  final Uri imageUrl;
  final String title;
  final String source;
  final String alt;
  final String copyright;
  final JSONMap metadata;
}

class RichTextLeafHardBreak extends RichTextLeaf {}

//
//
//
// MARK: - Component
//
//
//

sealed class RichTextComponent {
  RichTextComponent();

  factory RichTextComponent.fromJson(JSONMap json) {
    final type = json["type"];
    return switch (type) {
      "paragraph" => RichTextComponentParagraph.fromJson(json),
      "heading" => RichTextComponentHeading.fromJson(json),
      "blockquote" => RichTextComponentQuote.fromJson(json),
      "code_block" => RichTextComponentCode.fromJson(json),
      "horizontal_rule" => RichTextComponentLine(),
      "bullet_list" => RichTextComponentList.fromJson(json),
      "ordered_list" => RichTextComponentList.fromJson(json),
      "blok" => RichTextComponentBlok.fromJson(json),
      _ => UnrecognizedRichTextComponent(type, json),
    };
  }
}

class UnrecognizedRichTextComponent extends RichTextComponent {
  UnrecognizedRichTextComponent(this.type, this.data) {
    print("Unrecognized rich-text component: $type");
  }
  final String type;
  final JSONMap data;
}

// MARK: - Components

class RichTextComponentParagraph implements RichTextComponent, RichTextLeaf {
  RichTextComponentParagraph({
    required this.content,
  });
  factory RichTextComponentParagraph.fromJson(JSONMap json) => RichTextComponentParagraph(
        content: List<JSONMap>.from(json["content"] ?? []).map(RichTextLeaf.fromJson).toList(),
      );

  final List<RichTextLeaf> content;
}

class RichTextComponentHeading extends RichTextComponent {
  RichTextComponentHeading({
    required this.level,
    required this.content,
  });
  factory RichTextComponentHeading.fromJson(JSONMap json) => RichTextComponentHeading(
        level: json["attrs"]["level"],
        content: List<JSONMap>.from(json["content"]).map(RichTextLeaf.fromJson).toList(),
      );

  final int level;
  final List<RichTextLeaf> content;
}

class RichTextComponentCode extends RichTextComponent {
  RichTextComponentCode({required this.codeLanguage, required this.content});
  factory RichTextComponentCode.fromJson(JSONMap json) => RichTextComponentCode(
        codeLanguage: json["attrs"]["class"],
        content: List<JSONMap>.from(json["content"]).map(RichTextLeaf.fromJson).toList(),
      );

  final String codeLanguage;
  final List<RichTextLeaf> content;
}

class RichTextComponentLine extends RichTextComponent {}

class RichTextComponentQuote extends RichTextComponent {
  RichTextComponentQuote({required this.content});
  factory RichTextComponentQuote.fromJson(JSONMap json) => RichTextComponentQuote(
        content: List<JSONMap>.from(json["content"]).map(RichTextLeaf.fromJson).toList(),
      );

  final List<RichTextLeaf> content;
}

class RichTextComponentList extends RichTextComponent {
  RichTextComponentList({required this.rows, required this.isOrdered});
  factory RichTextComponentList.fromJson(JSONMap json) => RichTextComponentList(
        isOrdered: json["attrs"]?["order"] == 1,
        rows: List<JSONMap>.from(json["content"])
            .map((e) => RichTextComponentParagraph.fromJson(JSONMap.from(e["content"][0])))
            .toList(),
      );

  final bool isOrdered;
  final List<RichTextComponentParagraph> rows;
}

class RichTextComponentBlok extends RichTextComponent {
  RichTextComponentBlok({required this.id, required this.bloksData});
  factory RichTextComponentBlok.fromJson(JSONMap json) => RichTextComponentBlok(
        id: json["attrs"]["id"],
        bloksData: List.from(json["attrs"]["body"]),
      );

  final String id;
  final List<JSONMap> bloksData;
}
