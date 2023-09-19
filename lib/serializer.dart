import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/field_types.dart';
import 'package:flutter_storyblok/metadata.dart';
import 'package:flutter_storyblok/utils.dart';
import 'package:reflectable/reflectable.dart';

final class TypeSerializable<T> {
  final Type type;
  final T Function(JSONMap) serialize;

  const TypeSerializable(this.type, this.serialize);
}

final class StoryblokWidgetSerializer {
  final Set<TypeSerializable> types;
  final Reflectable reflectable;

  StoryblokWidgetSerializer(this.types, this.reflectable);

  StoryblokWidget serializeJson(JSONMap json) {
    final key = json["component"] as String;
    print(key);

    final componentType = types.firstWhereOrNull((e) {
      final mirror = reflectable.reflectType(e.type) as ClassMirror;
      final name = mirror.metadata.firstWhereOrNull((e) => e is Name) as Name?;
      return (name?.name ?? e.type.toString()) == key;
    });
    if (componentType == null) {
      throw "Unrecognized component: $key";
    }
    final componentMirror = reflectable.reflectType(componentType.type) as ClassMirror;
    final newMap = JSONMap();

    for (final entry in componentMirror.declarations.entries) {
      final fieldName = entry.key;
      final fieldMirror = tryCast<VariableMirror>(entry.value);
      if (fieldMirror == null) {
        print("Skip non-variable declaraion $fieldName");
        continue;
      }

      final name = fieldMirror.metadata.firstWhereOrNull((e) => e is Name) as Name?;
      String key = name?.name ?? fieldName;

      var value = json[key];
      if (value == null) {
        print("Unrecognized key: $key");
        continue;
      } //
      else if (!fieldMirror.hasReflectedType && fieldMirror.dynamicReflectedType is FieldType) {
        final t = reflectable.reflectType(fieldMirror.dynamicReflectedType) as ClassMirror;
        newMap[key] = t.newInstance("", [value]);
      } //
      else if (fieldMirror.type.isAssignableTo(reflectable.reflectType(FieldTypeBlocks))) {
        final t = reflectable.reflectType(FieldTypeBlocks) as ClassMirror;
        final jsonBlocks = List<JSONMap>.from(json[key]);
        final args = jsonBlocks.map((e) => serializeJson(Map.from(e))).toList();
        newMap[key] = t.newInstance("", [args]);
      } //
      else if (fieldMirror.type.isAssignableTo(reflectable.reflectType(FieldType))) {
        final t = fieldMirror.type as ClassMirror;
        if (t.typeArguments.isNotEmpty) {
          final a = t.typeArguments.whereType<ClassMirror>().toList().map((e) => e.newInstance("", [value])).toList();
          newMap[key] = t.newInstance("", a);
        } else {
          newMap[key] = t.newInstance("", [value]);
        }
      } //
      else {
        newMap[key] = value;
      }
    }
    return componentType.serialize(newMap);
  }
}

abstract class StoryblokWidget {
  const StoryblokWidget();
  Widget buildWidget(BuildContext context);
}
