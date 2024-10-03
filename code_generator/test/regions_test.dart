import 'package:flutter_storyblok/models.dart' as sb;
import 'package:flutter_storyblok_code_generator/src/http_client.dart';
import 'package:test/test.dart';

void main() {
  test('Test region url build', () {
    sb.Region.values.forEach(_expectRegion);
  });
}

void _expectRegion(sb.Region region) {
  switch (region) {
    case sb.Region.eu:
      expect(
        region.buildUri(path: "somePath"),
        Uri.parse("https://mapi.storyblok.com/somePath"),
      );
      expect(
        region.buildUri(path: "somePath", queryParameters: {"foo": "bar"}),
        Uri.parse("https://mapi.storyblok.com/somePath?foo=bar"),
      );
    case sb.Region.us:
      expect(
        region.buildUri(path: "somePath"),
        Uri.parse("https://api-us.storyblok.com/somePath"),
      );
      expect(
        region.buildUri(path: "somePath", queryParameters: {"foo": "bar"}),
        Uri.parse("https://api-us.storyblok.com/somePath?foo=bar"),
      );
    case sb.Region.ca:
      expect(
        region.buildUri(path: "somePath"),
        Uri.parse("https://api-ca.storyblok.com/somePath"),
      );
      expect(
        region.buildUri(path: "somePath", queryParameters: {"foo": "bar"}),
        Uri.parse("https://api-ca.storyblok.com/somePath?foo=bar"),
      );
    case sb.Region.ap:
      expect(
        region.buildUri(path: "somePath"),
        Uri.parse("https://api-ap.storyblok.com/somePath"),
      );
      expect(
        region.buildUri(path: "somePath", queryParameters: {"foo": "bar"}),
        Uri.parse("https://api-ap.storyblok.com/somePath?foo=bar"),
      );
    case sb.Region.cn:
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
