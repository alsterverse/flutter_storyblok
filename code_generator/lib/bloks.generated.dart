// storyblok_code_generator

// ignore_for_file: unused_import

library bloks; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:flutter_storyblok/asset.dart' as _i1;
import 'package:flutter_storyblok/link.dart' as _i2;
import 'package:flutter_storyblok/markdown.dart' as _i7;
import 'package:flutter_storyblok/plugin.dart' as _i4;
import 'package:flutter_storyblok/request_parameters.dart' as _i6;
import 'package:flutter_storyblok/rich_text.dart' as _i3;
import 'package:flutter_storyblok/table.dart' as _i5;

enum DefaultOption {
  foo('foo'),
  bar('bar'),
  unknown('unknown');

  const DefaultOption(this.raw);

  factory DefaultOption.fromName(String? name) {
    return switch (name) {
      "foo" => DefaultOption.foo,
      "bar" => DefaultOption.bar,
      _ => DefaultOption.unknown,
    };
  }

  final String raw;
}

enum Single2Option {
  hello('hello'),
  world('world'),
  unknown('unknown');

  const Single2Option(this.raw);

  factory Single2Option.fromName(String? name) {
    return switch (name) {
      "hello" => Single2Option.hello,
      "world" => Single2Option.world,
      _ => Single2Option.unknown,
    };
  }

  final String raw;
}

enum DirectionOption {
  vertical('v'),
  horizontal('h'),
  unknown('unknown');

  const DirectionOption(this.raw);

  factory DirectionOption.fromName(String? name) {
    return switch (name) {
      "v" => DirectionOption.vertical,
      "h" => DirectionOption.horizontal,
      _ => DirectionOption.unknown,
    };
  }

  final String raw;
}

enum Multi1Option {
  opt1('val1'),
  opt2('val2'),
  unknown('unknown');

  const Multi1Option(this.raw);

  factory Multi1Option.fromName(String? name) {
    return switch (name) {
      "val1" => Multi1Option.opt1,
      "val2" => Multi1Option.opt2,
      _ => Multi1Option.unknown,
    };
  }

  final String raw;
}

enum ExternalExternalOption {
  foo('foo'),
  bar('bar'),
  unknown('unknown');

  const ExternalExternalOption(this.raw);

  factory ExternalExternalOption.fromName(String? name) {
    return switch (name) {
      "foo" => ExternalExternalOption.foo,
      "bar" => ExternalExternalOption.bar,
      _ => ExternalExternalOption.unknown,
    };
  }

  final String raw;
}

enum Icons {
  start('start'),
  search('search'),
  blocks('blocks'),
  abcDef(' ghi jkl '),
  unknown('unknown');

  const Icons(this.raw);

  factory Icons.fromName(String? name) {
    return switch (name) {
      "start" => Icons.start,
      "search" => Icons.search,
      "blocks" => Icons.blocks,
      " ghi jkl " => Icons.abcDef,
      _ => Icons.unknown,
    };
  }

  final String raw;
}

enum PhoneHardware {
  camera('camera'),
  vibration('vibration'),
  accelerometer('accelerometer'),
  unknown('unknown');

  const PhoneHardware(this.raw);

  factory PhoneHardware.fromName(String? name) {
    return switch (name) {
      "camera" => PhoneHardware.camera,
      "vibration" => PhoneHardware.vibration,
      "accelerometer" => PhoneHardware.accelerometer,
      _ => PhoneHardware.unknown,
    };
  }

  final String raw;
}

enum Foo {
  bar('35baaaas'),
  $34mofo('boo'),
  unknown('unknown');

  const Foo(this.raw);

  factory Foo.fromName(String? name) {
    return switch (name) {
      "35baaaas" => Foo.bar,
      "boo" => Foo.$34mofo,
      _ => Foo.unknown,
    };
  }

  final String raw;
}

/// This class is generated, do not edit manually
sealed class Blok {
  Blok();

  factory Blok.fromJson(Map<String, dynamic> json) {
    switch (json["component"] as String) {
      case "bottom_navigation":
        return BottomNavigation.fromJson(json);
      case "bottom_navigation_item":
        return BottomNavigationItem.fromJson(json);
      case "carousel_block":
        return CarouselBlock.fromJson(json);
      case "content_editor":
        return ContentEditor.fromJson(json);
      case "feature":
        return Feature.fromJson(json);
      case "grid":
        return Grid.fromJson(json);
      case "hardware_button":
        return HardwareButton.fromJson(json);
      case "hero":
        return Hero.fromJson(json);
      case "image_block":
        return ImageBlock.fromJson(json);
      case "multi_page":
        return MultiPage.fromJson(json);
      case "page":
        return Page.fromJson(json);
      case "rich_block":
        return RichBlock.fromJson(json);
      case "Search page":
        return SearchPage.fromJson(json);
      case "start_page":
        return StartPage.fromJson(json);
      case "teaser":
        return Teaser.fromJson(json);
      case "test_block":
        return TestBlock.fromJson(json);
      case "test multi assets block":
        return TestMultiAssetsBlock.fromJson(json);
      case "Test Multi-options":
        return TestMultiOptions.fromJson(json);
      case "test-plugin":
        return TestPlugin.fromJson(json);
      case "Test table":
        return TestTable.fromJson(json);
      case "text_block":
        return TextBlock.fromJson(json);
      case "video_block":
        return VideoBlock.fromJson(json);
      case "video_item":
        return VideoItem.fromJson(json);
      case "video_page":
        return VideoPage.fromJson(json);
      default:
        print("Unrecognized type ${json["component"]}");
        return UnrecognizedBlok();
    }
  }
}

final class BottomNavigation extends Blok {
  BottomNavigation.fromJson(Map<String, dynamic> json)
      : items = List<Map<String, dynamic>>.from(json["items"] ?? const []).map(BottomNavigationItem.fromJson).toList();

  final List<BottomNavigationItem> items;
}

final class BottomNavigationItem extends Blok {
  BottomNavigationItem.fromJson(Map<String, dynamic> json)
      : label = json["label"],
        icon = _i1.ImageAsset.fromJson(Map<String, dynamic>.from(json["icon"])),
        page = _i2.BaseLinkTypes.fromJson(Map<String, dynamic>.from(json["page"]));

  final String label;

  final _i1.ImageAsset icon;

  final _i2.BaseLinkTypes page;
}

final class CarouselBlock extends Blok {
  CarouselBlock.fromJson(Map<String, dynamic> json)
      : heading = json["heading"],
        videos = List<Map<String, dynamic>>.from(json["videos"] ?? const []).map(VideoItem.fromJson).toList(),
        showInfo = json["show_info"] ?? false,
        isNotable = json["is_notable"] ?? false;

  final String heading;

  final List<VideoItem> videos;

  final bool showInfo;

  final bool isNotable;
}

final class ContentEditor extends Blok {
  ContentEditor.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        image = _i1.ImageAsset.fromJson(Map<String, dynamic>.from(json["image"])),
        direction = DirectionOption.fromName(json["direction"]);

  final String name;

  final _i1.ImageAsset image;

  final DirectionOption direction;
}

final class Feature extends Blok {
  Feature.fromJson(Map<String, dynamic> json) : name = json["name"];

  final String? name;
}

final class Grid extends Blok {
  Grid.fromJson(Map<String, dynamic> json)
      : columns = List<Map<String, dynamic>>.from(json["columns"] ?? const []).map(Blok.fromJson).toList();

  final List<Blok> columns;
}

final class HardwareButton extends Blok {
  HardwareButton.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        sensor = PhoneHardware.fromName(json["sensor"]);

  final String title;

  final PhoneHardware sensor;
}

final class Hero extends Blok {
  Hero.fromJson(Map<String, dynamic> json)
      : video = List<Map<String, dynamic>>.from(json["video"] ?? const []).map(VideoItem.fromJson).toList().first;

  final VideoItem video;
}

final class ImageBlock extends Blok {
  ImageBlock.fromJson(Map<String, dynamic> json)
      : image = _i1.ImageAsset.fromJson(Map<String, dynamic>.from(json["image"]));

  final _i1.ImageAsset image;
}

final class MultiPage extends Blok {
  MultiPage.fromJson(Map<String, dynamic> json)
      : titel = json["Titel"],
        content = List<Map<String, dynamic>>.from(json["content"] ?? const []).map(Blok.fromJson).toList();

  final String? titel;

  final List<Blok> content;
}

final class Page extends Blok {
  Page.fromJson(Map<String, dynamic> json)
      : body = List<Map<String, dynamic>>.from(json["body"] ?? const []).map(Blok.fromJson).toList();

  final List<Blok> body;
}

final class RichBlock extends Blok {
  RichBlock.fromJson(Map<String, dynamic> json) : richTextHeader = _i3.RichText.fromJson(json["richTextHeader"]);

  final _i3.RichText? richTextHeader;
}

final class SearchPage extends Blok {
  SearchPage.fromJson(Map<String, dynamic> json) : topHeader = json["topHeader"];

  final String topHeader;
}

final class StartPage extends Blok {
  StartPage.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        content = List<Map<String, dynamic>>.from(json["content"] ?? const []).map(Blok.fromJson).toList();

  final String title;

  final List<Blok> content;
}

final class Teaser extends Blok {
  Teaser.fromJson(Map<String, dynamic> json) : headline = json["headline"];

  final String? headline;
}

final class TestBlock extends Blok {
  TestBlock.fromJson(Map<String, dynamic> json)
      : bloks1 = List<Map<String, dynamic>>.from(json["bloks1"] ?? const []).map(Blok.fromJson).toList(),
        single2 = Single2Option.fromName(json["single2"]),
        plugin1 = json["plugin1"] is! Map<dynamic, dynamic> ? null : _i4.Plugin.fromJson(json["plugin1"]),
        plugin2 = json["plugin2"] is! Map<dynamic, dynamic> ? null : _i4.Plugin.fromJson(json["plugin2"]),
        table1 = _i5.Table.fromJson(json["table1"]),
        reference1 = List<String>.from(json["reference1"] ?? const []).map(_i6.StoryIdentifierUUID?.new).toList(),
        bloks2 = List<Map<String, dynamic>>.from(json["bloks2"] ?? const []).map(Blok.fromJson).toList(),
        text1 = json["text1"],
        text2 = json["text2"],
        textarea1 = json["textarea1"],
        textarea2 = json["textarea2"],
        richtext1 = _i3.RichText.fromJson(json["richtext1"]),
        richtext2 = _i3.RichText.fromJson(json["richtext2"]),
        markdown1 = _i7.Markdown(json["markdown1"]),
        markdown2 = _i7.Markdown(json["markdown2"]),
        number1 = double.tryParse(json["number1"]),
        number2 = int.parse(json["number2"]),
        number3 = double.tryParse(json["number3"]),
        datetime1 = DateTime.tryParse(json["datetime1"]),
        bool1 = json["bool1"] ?? false,
        multi1 = List<String>.from(json["multi1"] ?? const []).map(Multi1Option.fromName).toList(),
        multi2 = List<String>.from(json["multi2"] ?? const []).map(_i6.StoryIdentifierUUID.new).toList(),
        multi3 = List<String>.from(json["multi3"] ?? const []),
        multi4 = List<String>.from(json["multi4"] ?? const []).map(Icons.fromName).toList(),
        single1 = Icons.fromName(json["single1"]),
        asset1 = _i1.Asset.fromJson(Map<String, dynamic>.from(json["asset1"])),
        asset2 = _i1.Asset.fromJson(Map<String, dynamic>.from(json["asset2"])),
        masset1 = List<Map<String, dynamic>>.from(json["masset1"] ?? const []).map(_i1.Asset.fromJson).toList(),
        link1 = _i2.BaseLinkTypes.fromJson(Map<String, dynamic>.from(json["link1"]));

  final List<Blok>? bloks1;

  final Single2Option single2;

  final _i4.Plugin? plugin1;

  final _i4.Plugin? plugin2;

  final _i5.Table table1;

  final List<_i6.StoryIdentifierUUID> reference1;

  final List<Blok> bloks2;

  final String? text1;

  final String text2;

  final String? textarea1;

  final String textarea2;

  final _i3.RichText? richtext1;

  final _i3.RichText richtext2;

  final _i7.Markdown? markdown1;

  final _i7.Markdown markdown2;

  final double? number1;

  final int number2;

  final double? number3;

  final DateTime? datetime1;

  final bool bool1;

  final List<Multi1Option> multi1;

  final List<_i6.StoryIdentifierUUID> multi2;

  final List<String> multi3;

  final List<Icons> multi4;

  final Icons single1;

  final _i1.Asset? asset1;

  final _i1.Asset? asset2;

  final List<_i1.Asset> masset1;

  final _i2.BaseLinkTypes? link1;
}

final class TestMultiAssetsBlock extends Blok {
  TestMultiAssetsBlock.fromJson(Map<String, dynamic> json)
      : testMultiAssets =
            List<Map<String, dynamic>>.from(json["testMultiAssets"] ?? const []).map(_i1.Asset.fromJson).toList();

  final List<_i1.Asset> testMultiAssets;
}

final class TestMultiOptions extends Blok {
  TestMultiOptions.fromJson(Map<String, dynamic> json)
      : $default = List<String>.from(json["default"] ?? const []).map(DefaultOption.fromName).toList(),
        stories = List<String>.from(json["stories"] ?? const []).map(_i6.StoryIdentifierUUID?.new).toList(),
        languages = List<String>.from(json["languages"] ?? const []),
        datasource = List<String>.from(json["datasource"] ?? const []).map(Icons.fromName).toList(),
        $external = List<String>.from(json["external"] ?? const []).map(ExternalExternalOption.fromName).toList();

  final List<DefaultOption> $default;

  final List<_i6.StoryIdentifierUUID> stories;

  final List<String> languages;

  final List<Icons> datasource;

  final List<ExternalExternalOption> $external;
}

final class TestPlugin extends Blok {
  TestPlugin.fromJson(Map<String, dynamic> json)
      : plugin = json["plugin"] is! Map<dynamic, dynamic> ? null : _i4.Plugin.fromJson(json["plugin"]),
        nullable = json["nullable"] is! Map<dynamic, dynamic> ? null : _i4.Plugin.fromJson(json["nullable"]),
        plugin2 = _i4.Plugin.fromJson(json["plugin2"]);

  final _i4.Plugin? plugin;

  final _i4.Plugin? nullable;

  final _i4.Plugin plugin2;
}

final class TestTable extends Blok {
  TestTable.fromJson(Map<String, dynamic> json)
      : defaultTable = _i5.Table.fromJson(json["Default_table"]),
        translatable = _i5.Table.fromJson(json["translatable"]),
        empty = _i5.Table.fromJson(json["empty"]);

  final _i5.Table defaultTable;

  final _i5.Table translatable;

  final _i5.Table empty;
}

final class TextBlock extends Blok {
  TextBlock.fromJson(Map<String, dynamic> json)
      : heading = json["heading"],
        body = json["body"];

  final String? heading;

  final String? body;
}

final class VideoBlock extends Blok {
  VideoBlock.fromJson(Map<String, dynamic> json)
      : videos = _i1.VideoAsset.fromJson(Map<String, dynamic>.from(json["videos"]));

  final _i1.VideoAsset videos;
}

final class VideoItem extends Blok {
  VideoItem.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        videoLink = _i2.BaseLinkTypes.fromJson(Map<String, dynamic>.from(json["video_link"])),
        description = json["description"],
        summary = json["summary"],
        airDate = DateTime.tryParse(json["air_date"]);

  final String? title;

  final _i2.BaseLinkTypes videoLink;

  final String? description;

  final String? summary;

  final DateTime? airDate;
}

final class VideoPage extends Blok {
  VideoPage.fromJson(Map<String, dynamic> json)
      : videoTitle = json["video_title"],
        videoUrl = _i2.BaseLinkTypes.fromJson(Map<String, dynamic>.from(json["video_url"])),
        videoThumbnail = _i2.BaseLinkTypes.fromJson(Map<String, dynamic>.from(json["video_thumbnail"])),
        videoDescription = json["video_description"],
        publishedAt = DateTime.parse(json["published_at"]);

  final String videoTitle;

  final _i2.BaseLinkTypes videoUrl;

  final _i2.BaseLinkTypes videoThumbnail;

  final String videoDescription;

  final DateTime publishedAt;
}

final class UnrecognizedBlok extends Blok {}
