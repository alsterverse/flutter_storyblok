import 'package:flutter_storyblok_code_generator/src/utils/utils.dart';

enum Region {
  eu,
  us,
  ap,
  ca,
  cn,
}

extension RegionExtension on Region {
  String get host {
    switch (this) {
      case Region.eu:
        return "mapi.storyblok.com";
      case Region.us:
        return "api-us.storyblok.com";
      case Region.ap:
        return "api-ap.storyblok.com";
      case Region.ca:
        return "api-ca.storyblok.com";
      case Region.cn:
        return "app.storyblokchina.cn";
      default:
        return "mapi.storyblok.com";
    }
  }
}

Region stringToRegion(String region) {
  switch (region.toLowerCase()) {
    case 'eu':
      return Region.eu;
    case 'us':
      return Region.us;
    case 'ap':
      return Region.ap;
    case 'ca':
      return Region.ca;
    case 'cn':
      return Region.cn;
    default:
      throwMessage("Invalid region '$region'. Available options are 'eu', 'us', 'ap', 'ca', 'cn'");
  }
}
