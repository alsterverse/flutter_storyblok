//

import 'package:flutter_storyblok/link.dart';
import 'package:flutter_storyblok/utils.dart';

final class RichText {
  String type;
  List<RichTextContainer> content;

  RichText({required this.type, required this.content});

  factory RichText.fromJson(Map<String, dynamic> json) {
    return RichText(
      type: json['type'],
      content: List<JSONMap>.from(json['content']).map(RichTextContainer.fromJson).toList(),
    );
  }
}

// MARK: - Component
//
//

/// RichTextContainer contains leaves and other containers
/// e.g a Paragraph can contain Text leaves but also another Paragraph.
sealed class RichTextContainer {
  RichTextContainer();

  factory RichTextContainer.fromJson(JSONMap json) {
    final type = json["type"];
    return switch (type) {
      "paragraph" => RichTextContainerParagraph.fromJson(json),
      "heading" => RichTextContainerHeading.fromJson(json),
      "blockquote" => RichTextContainerQuote.fromJson(json),
      "code_block" => RichTextContainerCode.fromJson(json),
      "horizontal_rule" => RichTextContainerLine(),
      "bullet_list" => RichTextContainerList.fromJson(json, isOrdered: false),
      "ordered_list" => RichTextContainerList.fromJson(json, isOrdered: true),
      "blok" => RichTextContainerBlok.fromJson(json),
      _ => UnrecognizedRichTextContainer(type, json),
    };
  }
}

final class UnrecognizedRichTextContainer extends RichTextContainer {
  UnrecognizedRichTextContainer(this.type, this.data) {
    print("Unrecognized richtext container: $type");
  }
  final String type;
  final JSONMap data;
}

// MARK: - Components

/// A text box
/// Paragraph is both a Container and a Leaf since it can exist inside another Container e.g List
final class RichTextContainerParagraph implements RichTextContainer, RichTextLeaf {
  RichTextContainerParagraph({
    required this.content,
  });
  factory RichTextContainerParagraph.fromJson(JSONMap json) => RichTextContainerParagraph(
        content: List<JSONMap>.from(json["content"] ?? []).map(RichTextLeaf.fromJson).toList(),
      );

  final List<RichTextLeaf> content;
}

/// A heading text box
final class RichTextContainerHeading implements RichTextContainer {
  RichTextContainerHeading({
    required this.level,
    required this.content,
  });
  factory RichTextContainerHeading.fromJson(JSONMap json) => RichTextContainerHeading(
        level: json["attrs"]["level"],
        content: List<JSONMap>.from(json["content"]).map(RichTextLeaf.fromJson).toList(),
      );

  final int level;
  final List<RichTextLeaf> content;
}

/// A code text box
final class RichTextContainerCode implements RichTextContainer {
  RichTextContainerCode({required this.codeLanguage, required this.content});
  factory RichTextContainerCode.fromJson(JSONMap json) => RichTextContainerCode(
        codeLanguage: json["attrs"]["class"],
        content: List<JSONMap>.from(json["content"]).map(RichTextLeaf.fromJson).toList(),
      );

  final String codeLanguage;
  final List<RichTextLeaf> content;
}

/// A horizontal line
final class RichTextContainerLine implements RichTextContainer {}

/// A quote text box
final class RichTextContainerQuote implements RichTextContainer {
  RichTextContainerQuote({required this.content});
  factory RichTextContainerQuote.fromJson(JSONMap json) => RichTextContainerQuote(
        content: List<JSONMap>.from(json["content"]).map(RichTextLeaf.fromJson).toList(),
      );

  final List<RichTextLeaf> content;
}

/// An un/ordered list of Paragraphs
final class RichTextContainerList implements RichTextContainer {
  RichTextContainerList({required this.rows, required this.isOrdered});
  factory RichTextContainerList.fromJson(JSONMap json, {required bool isOrdered}) => RichTextContainerList(
        isOrdered: isOrdered,
        rows: List<JSONMap>.from(json["content"])
            // Each object is of type "list_item" which only ever contains a single Paragraph object named "content".
            .map((e) => RichTextContainerParagraph.fromJson(JSONMap.from(e["content"][0])))
            .toList(),
      );

  final bool isOrdered;
  final List<RichTextContainerParagraph> rows;
}

/// A list of bloks
final class RichTextContainerBlok implements RichTextContainer {
  RichTextContainerBlok({required this.id, required this.bloksData});
  factory RichTextContainerBlok.fromJson(JSONMap json) => RichTextContainerBlok(
        id: json["attrs"]["id"],
        bloksData: List.from(json["attrs"]["body"]),
      );

  final String id;
  final List<JSONMap> bloksData;
}

// MARK: - Leaf
//
//

/// Leaves exists inside a container
sealed class RichTextLeaf {
  RichTextLeaf();
  factory RichTextLeaf.fromJson(JSONMap json) {
    final type = json["type"];
    return switch (type) {
      "text" => RichTextLeafText.fromJson(json),
      "emoji" => RichTextLeafEmoji.fromJson(json),
      "image" => RichTextLeafImage.fromJson(json),
      "hard_break" => RichTextLeafHardBreak(),
      "paragraph" => RichTextContainerParagraph.fromJson(json),
      _ => UnrecognizedRichTextLeaf(type, json),
    } as RichTextLeaf;
  }
}

final class UnrecognizedRichTextLeaf implements RichTextLeaf {
  UnrecognizedRichTextLeaf(this.type, this.data) {
    print("Unrecognized richtext leaf: $type");
  }
  final String type;
  final JSONMap data;
}

// MARK: - Leaves
//
//

final class RichTextLeafText extends RichTextLeafMarkable implements RichTextLeaf {
  RichTextLeafText({required this.text, required List<RichTextLeafMark> marks}) : super(marks: marks);
  factory RichTextLeafText.fromJson(JSONMap json) => RichTextLeafText(
        text: json["text"],
        marks: RichTextLeafMarkable.marksFromJson(json),
      );

  final String text;
}

final class RichTextLeafEmoji extends RichTextLeafMarkable implements RichTextLeaf {
  RichTextLeafEmoji({
    required this.name,
    required this.text,
    required this.fallback,
    required List<RichTextLeafMark> marks,
  }) : super(marks: marks);
  factory RichTextLeafEmoji.fromJson(JSONMap json) => RichTextLeafEmoji(
        name: json["attrs"]["name"],
        text: json["attrs"]["emoji"],
        fallback: mapIfNotNull(json["attrs"]["fallbackImage"] as String?, Uri.parse),
        marks: RichTextLeafMarkable.marksFromJson(json),
      );
  final String name;
  final String? text;
  final Uri? fallback;
}

final class RichTextLeafImage extends RichTextLeafMarkable implements RichTextLeaf {
  RichTextLeafImage({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.source,
    required this.alt,
    required this.copyright,
    required this.metadata,
    required List<RichTextLeafMark> marks,
  }) : super(marks: marks);
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
      marks: RichTextLeafMarkable.marksFromJson(json),
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

final class RichTextLeafHardBreak implements RichTextLeaf {}

// MARK: - Mark
//
//

/// A Mark instructs the leaf to be a certain style e.g bold, italic, underlined etc.
sealed class RichTextLeafMark {
  RichTextLeafMark();
  factory RichTextLeafMark.fromJson(JSONMap json) {
    final type = json["type"];
    return switch (type) {
      "bold" => RichTextLeafMarkBold(),
      "italic" => RichTextLeafMarkItalic(),
      "strike" => RichTextLeafMarkStrike(),
      "underline" => RichTextLeafMarkUnderline(),
      "superscript" => RichTextLeafMarkSuperscript(),
      "subscript" => RichTextLeafMarkSubscript(),
      "code" => RichTextLeafMarkCode(),
      "anchor" => RichTextLeafMarkAnchor.fromJson(json),
      "link" => RichTextLeafMarkLink.fromJson(json),
      "textStyle" => RichTextLeafMarkTextStyle.fromJson(json),
      "highlight" => RichTextLeafMarkHighlight.fromJson(json),
      _ => UnrecognizedRichTextLeafMark(type, json),
    };
  }
}

final class UnrecognizedRichTextLeafMark implements RichTextLeafMark {
  UnrecognizedRichTextLeafMark(this.type, this.data) {
    print("Unrecognized richtext mark: $type");
  }
  final String type;
  final JSONMap data;
}

// MARK: - Marks

final class RichTextLeafMarkBold implements RichTextLeafMark {}

final class RichTextLeafMarkItalic implements RichTextLeafMark {}

final class RichTextLeafMarkStrike implements RichTextLeafMark {}

final class RichTextLeafMarkUnderline implements RichTextLeafMark {}

final class RichTextLeafMarkSuperscript implements RichTextLeafMark {}

final class RichTextLeafMarkSubscript implements RichTextLeafMark {}

final class RichTextLeafMarkCode implements RichTextLeafMark {}

final class RichTextLeafMarkAnchor implements RichTextLeafMark {
  RichTextLeafMarkAnchor({required this.id});
  factory RichTextLeafMarkAnchor.fromJson(JSONMap json) => RichTextLeafMarkAnchor(
        id: json["attrs"]["id"],
      );
  final String id;
}

final class RichTextLeafMarkLink implements RichTextLeafMark {
  RichTextLeafMarkLink({required this.link});
  factory RichTextLeafMarkLink.fromJson(JSONMap json) => RichTextLeafMarkLink(
        link: Link.fromJson(json["attrs"]),
      );
  final Link? link;
}

final class RichTextLeafMarkTextStyle implements RichTextLeafMark {
  RichTextLeafMarkTextStyle({required this.colorHex});
  factory RichTextLeafMarkTextStyle.fromJson(JSONMap json) => RichTextLeafMarkTextStyle(
        colorHex: json["attrs"]["color"],
      );
  final String colorHex;
}

final class RichTextLeafMarkHighlight implements RichTextLeafMark {
  RichTextLeafMarkHighlight({required this.colorHex});
  factory RichTextLeafMarkHighlight.fromJson(JSONMap json) => RichTextLeafMarkHighlight(
        colorHex: json["attrs"]["color"],
      );
  final String colorHex;
}

class RichTextLeafMarkable {
  static List<RichTextLeafMark> marksFromJson(JSONMap json) =>
      List<JSONMap>.from(json["marks"] ?? []).map(RichTextLeafMark.fromJson).toList();

  RichTextLeafMarkable({required List<RichTextLeafMark> marks})
      : isCode = marks.containsType<RichTextLeafMarkCode>(),
        isBold = marks.containsType<RichTextLeafMarkBold>(),
        isItalic = marks.containsType<RichTextLeafMarkItalic>(),
        isStriked = marks.containsType<RichTextLeafMarkStrike>(),
        isUnderlined = marks.containsType<RichTextLeafMarkUnderline>(),
        isSuperscript = marks.containsType<RichTextLeafMarkSuperscript>(),
        isSubscript = marks.containsType<RichTextLeafMarkSubscript>(),
        anchor = marks.firstAsType(),
        link = marks.firstAsType(),
        backgroundColor = marks.firstAsType(),
        foregroundColor = marks.firstAsType();
  final bool isCode;
  final bool isBold;
  final bool isItalic;
  final bool isStriked;
  final bool isUnderlined;
  final bool isSuperscript;
  final bool isSubscript;
  final RichTextLeafMarkAnchor? anchor;
  final RichTextLeafMarkLink? link;
  final RichTextLeafMarkHighlight? backgroundColor;
  final RichTextLeafMarkTextStyle? foregroundColor;
}
