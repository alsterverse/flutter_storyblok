import 'package:flutter_storyblok/models.dart';
import 'package:flutter_storyblok_code_generator/src/utils/utils.dart';

extension RegionCodeGen on Region {
  static Region fromString(String string) {
    final nameMap = Region.values.asNameMap();
    final region = nameMap[string];
    if (region != null) {
      return region;
    }
    throwMessage(
      "Invalid location '$string'. Available options are ${Region.values.map((e) => "'${e.name}'").join(", ")}",
    );
  }

  String get baseUrl {
    switch (this) {
      case Region.eu:
        return "https://mapi.storyblok.com";
      case Region.us:
        return "https://api-us.storyblok.com";
      case Region.ap:
        return "https://api-ap.storyblok.com";
      case Region.ca:
        return "https://api-ca.storyblok.com";
      case Region.cn:
        return "https://app.storyblokchina.cn";
      default:
        return "https://mapi.storyblok.com";
    }
  }

  Uri buildUri({required String path, JSONMap? queryParameters}) {
    return Uri.parse("$baseUrl/$path").replace(queryParameters: queryParameters);
  }
}
