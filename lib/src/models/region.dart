enum Region {
  eu,
  us,
  ap,
  ca,
  cn,
}

extension RegionHost on Region {
  String get host {
    switch (this) {
      case Region.eu:
        return "api.storyblok.com/v2";
      case Region.us:
        return "api-us.storyblok.com/v2";
      case Region.ap:
        return "api-ap.storyblok.com/v2";
      case Region.ca:
        return "api-ca.storyblok.com/v2";
      case Region.cn:
        return "app.storyblokchina.cn";
    }
  }
}
