// import 'package:flutter_storyblok/link_type.dart';
// import 'package:flutter_storyblok/reflector.dart';
import 'package:flutter_storyblok/utils.dart';

// @reflector
// sealed class FieldType {
//   const FieldType();
// }

// @reflector // Cannot use implements needs to use extends or else the reflector doesnt work
// final class FieldTypeText extends FieldType {
//   final String text;
//   const FieldTypeText(this.text);
// }

// @reflector // Cannot use implements needs to use extends or else the reflector doesnt work
// final class FieldTypeTextArea extends FieldTypeText {
//   const FieldTypeTextArea(super.text);
// }

// @reflector // Cannot use implements needs to use extends or else the reflector doesnt work
// final class FieldTypeMarkdown extends FieldTypeText {
//   const FieldTypeMarkdown(super.text);
// }

// @reflector // Cannot use implements needs to use extends or else the reflector doesnt work
// final class FieldTypeNumber extends FieldType {
//   final int value;
//   FieldTypeNumber(String strValue) : value = int.parse(strValue);
// }

// @reflector // Cannot use implements needs to use extends or else the reflector doesnt work
// final class FieldTypeBoolean extends FieldType {
//   final bool value;
//   const FieldTypeBoolean(this.value);
// }

// @reflector // Cannot use implements needs to use extends or else the reflector doesnt work
// final class FieldTypeLink extends FieldType {
//   final LinkType linkType;
//   FieldTypeLink(JSONMap json) : linkType = LinkType.fromJson(json);
// }

// @reflector // Cannot use implements needs to use extends or else the reflector doesnt work
// final class FieldTypeDateTime extends FieldType {
//   final DateTime dateTime;
//   FieldTypeDateTime(String value) : dateTime = DateTime.parse(value);
// }

// @reflector
// final class FieldTypeAsset extends FieldType {
//   final String fileName;
//   FieldTypeAsset(JSONMap json) : fileName = json["filename"];
// }

// @reflector
// final class FieldTypeValue<T> extends FieldType {
//   final T value;
//   FieldTypeValue(this.value);
//   factory FieldTypeValue.from(FieldTypeValue<dynamic> other) {
//     return FieldTypeValue(other.value);
//   }
// }

// @reflector
// final class FieldTypeBlocks<T extends Block> extends FieldType {
//   final List<T> blocks;
//   const FieldTypeBlocks(this.blocks);
//   factory FieldTypeBlocks.from(FieldTypeBlocks<dynamic> other) {
//     return FieldTypeBlocks(List.from(other.blocks));
//   }
// }

// abstract class Block {
//   const Block();
// }

final class SBAsset {
  final String alt;
  final String name;
  final String focus;
  final String title;
  final String copyright;
  final String fileName;
  final JSONMap metadata;
  SBAsset.fromJson(JSONMap json)
      : alt = json["alt"],
        name = json["name"],
        focus = json["focus"],
        title = json["title"],
        copyright = json["copyright"],
        fileName = json["fileName"],
        metadata = json["metadata"];
}
