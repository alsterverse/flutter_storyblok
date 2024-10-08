import 'package:flutter_storyblok/models.dart';
import 'package:flutter_storyblok/src/storyblok_client.dart';
import 'package:test/test.dart';

void main() {
  test('Test region url build', () {
    Region.values.forEach(_expectRegion);
  });
}

void _expectRegion(Region region) {
  switch (region) {
    case Region.eu:
      expect(
        region.buildUri(path: "somePath"),
        Uri.parse("https://api.storyblok.com/v2/cdn/somePath"),
      );
      expect(
        region.buildUri(path: "somePath", queryParameters: {"foo": "bar"}),
        Uri.parse("https://api.storyblok.com/v2/cdn/somePath?foo=bar"),
      );
    case Region.us:
      expect(
        region.buildUri(path: "somePath"),
        Uri.parse("https://api-us.storyblok.com/v2/cdn/somePath"),
      );
      expect(
        region.buildUri(path: "somePath", queryParameters: {"foo": "bar"}),
        Uri.parse("https://api-us.storyblok.com/v2/cdn/somePath?foo=bar"),
      );
    case Region.ca:
      expect(
        region.buildUri(path: "somePath"),
        Uri.parse("https://api-ca.storyblok.com/v2/cdn/somePath"),
      );
      expect(
        region.buildUri(path: "somePath", queryParameters: {"foo": "bar"}),
        Uri.parse("https://api-ca.storyblok.com/v2/cdn/somePath?foo=bar"),
      );
    case Region.ap:
      expect(
        region.buildUri(path: "somePath"),
        Uri.parse("https://api-ap.storyblok.com/v2/cdn/somePath"),
      );
      expect(
        region.buildUri(path: "somePath", queryParameters: {"foo": "bar"}),
        Uri.parse("https://api-ap.storyblok.com/v2/cdn/somePath?foo=bar"),
      );
    case Region.cn:
      expect(
        region.buildUri(path: "somePath"),
        Uri.parse("https://app.storyblokchina.cn/somePath"),
      );
      expect(
        region.buildUri(path: "somePath", queryParameters: {"foo": "bar"}),
        Uri.parse("https://app.storyblokchina.cn/somePath?foo=bar"),
      );
  }
}
