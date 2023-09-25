import 'package:flutter_storyblok/field_types.dart';
import 'package:flutter_storyblok/link_type.dart';

enum Icons { start }

enum PhoneHardware { camera, vibration, accelerometer }

enum Single2Option { hello, world }

sealed class Blok {
  Blok();

  factory Blok.fromJson(Map<String, dynamic> json) => switch (json["component"] as String) {
        "hardware_button" => HardwareButton.fromJson(json),
        "hero" => Hero.fromJson(json),
        "page" => Page.fromJson(json),
        "start_page" => StartPage.fromJson(json),
        "test_block" => TestBlock.fromJson(json),
        "video_item" => VideoItem.fromJson(json),
        "video_page" => VideoPage.fromJson(json),
        _ => throw "Unrecognized type ${json["component"]}",
      };
}

final class HardwareButton extends Blok {
  HardwareButton.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        sensor = PhoneHardware.values.byName(json["sensor"]);

  final String title;

  final PhoneHardware sensor;
}

final class Hero extends Blok {
  Hero.fromJson(Map<String, dynamic> json);
}

final class Page extends Blok {
  Page.fromJson(Map<String, dynamic> json)
      : blocks = List<Map<String, dynamic>>.from(json["blocks"]).map(Blok.fromJson).toList();

  final List<Blok>? blocks;
}

final class StartPage extends Blok {
  StartPage.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        label = json["label"],
        icon = Icons.values.byName(json["icon"]),
        content = List<Map<String, dynamic>>.from(json["content"]).map(Blok.fromJson).toList();

  final String? title;

  final String? label;

  final Icons? icon;

  final List<Blok> content;
}

final class TestBlock extends Blok {
  TestBlock.fromJson(Map<String, dynamic> json)
      : bloks1 = List<Map<String, dynamic>>.from(json["bloks1"]).map(Blok.fromJson).toList(),
        bloks2 = List<Map<String, dynamic>>.from(json["bloks2"]).map(Blok.fromJson).toList(),
        text1 = json["text1"],
        text2 = json["text2"],
        textarea1 = json["textarea1"],
        textarea2 = json["textarea2"],
        markdown1 = json["markdown1"],
        markdown2 = json["markdown2"],
        number1 = double.tryParse(json["number1"]),
        number2 = int.parse(json["number2"]),
        number3 = double.tryParse(json["number3"]),
        datetime1 = DateTime.tryParse(json["datetime1"]),
        bool1 = json["bool1"],
        single1 = Icons.values.byName(json["single1"]),
        asset1 = SBAsset.fromJson(Map<String, dynamic>.from(json["asset1"])),
        asset2 = SBAsset.fromJson(Map<String, dynamic>.from(json["asset2"])),
        link1 = LinkType.fromJson(Map<String, dynamic>.from(json["link1"])),
        single2 = Single2Option.values.byName(json["single2"]);

  final List<Blok>? bloks1;

  final List<Blok> bloks2;

  final String? text1;

  final String text2;

  final String? textarea1;

  final String textarea2;

  final String? markdown1;

  final String markdown2;

  final double? number1;

  final int number2;

  final double? number3;

  final DateTime? datetime1;

  final bool? bool1;

  final Icons? single1;

  final SBAsset? asset1;

  final SBAsset? asset2;

  final LinkType? link1;

  final Single2Option? single2;
}

final class VideoItem extends Blok {
  VideoItem.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        videoLink = LinkType.fromJson(Map<String, dynamic>.from(json["video_link"])),
        description = json["description"],
        summary = json["summary"],
        airDate = DateTime.tryParse(json["air_date"]);

  final String? title;

  final LinkType videoLink;

  final String? description;

  final String? summary;

  final DateTime? airDate;
}

final class VideoPage extends Blok {
  VideoPage.fromJson(Map<String, dynamic> json)
      : videoTitle = json["video_title"],
        videoUrl = LinkType.fromJson(Map<String, dynamic>.from(json["video_url"])),
        videoThumbnail = LinkType.fromJson(Map<String, dynamic>.from(json["video_thumbnail"])),
        videoDescription = json["video_description"],
        publishedAt = DateTime.parse(json["published_at"]);

  final String videoTitle;

  final LinkType videoUrl;

  final LinkType videoThumbnail;

  final String videoDescription;

  final DateTime publishedAt;
}
