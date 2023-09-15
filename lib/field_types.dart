import 'package:flutter_storyblok/reflector.dart';
import 'package:flutter_storyblok/serializer.dart';
import 'package:flutter_storyblok/utils.dart';

@reflector
// TODO: Rename to FieldType
sealed class Serializable {
  const Serializable();
}

@reflector // Cannot use implements needs to use extends or else the reflector doesnt work
final class SerializableText extends Serializable {
  final String text;
  const SerializableText(this.text);
}

@reflector // Cannot use implements needs to use extends or else the reflector doesnt work
final class SerializableTextArea extends SerializableText {
  const SerializableTextArea(super.text);
}

@reflector // Cannot use implements needs to use extends or else the reflector doesnt work
final class SerializableMarkdown extends SerializableText {
  const SerializableMarkdown(super.text);
}

@reflector // Cannot use implements needs to use extends or else the reflector doesnt work
final class SerializableNumber extends Serializable {
  final num value;
  const SerializableNumber(this.value);
}

@reflector // Cannot use implements needs to use extends or else the reflector doesnt work
final class SerializableBoolean extends Serializable {
  final bool value;
  const SerializableBoolean(this.value);
}

@reflector // Cannot use implements needs to use extends or else the reflector doesnt work
final class SerializableLink extends Serializable {
  final String uuid;
  final String linkType;
  final String fieldType;
  final Uri? url;
  SerializableLink(JSONMap json)
      : uuid = json["id"],
        linkType = json["linktype"],
        fieldType = json["fieldtype"],
        url = Uri.tryParse(json["fieldtype"]);
}

@reflector // Cannot use implements needs to use extends or else the reflector doesnt work
final class SerializableDateTime extends Serializable {
  final DateTime dateTime;
  SerializableDateTime(String value) : dateTime = DateTime.parse(value);
}

@reflector
final class SerializableAsset extends Serializable {
  final String fileName;
  SerializableAsset(JSONMap json) : fileName = json["filename"];
}

@reflector
final class SerializableSingleValue<T> extends Serializable {
  final T value;
  SerializableSingleValue(this.value);
  factory SerializableSingleValue.from(SerializableSingleValue<dynamic> other) {
    return SerializableSingleValue(other.value);
  }
}

@reflector
class SerializableSingleValueType {}

@reflector
final class SerializableBlocks<T extends StoryblokWidgetable> extends Serializable {
  final List<T> blocks;
  const SerializableBlocks(this.blocks);
  factory SerializableBlocks.from(SerializableBlocks<dynamic> other) {
    return SerializableBlocks(List.from(other.blocks));
  }
}
