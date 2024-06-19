![](./flutter_storyblok.png)

This Flutter project integrates with [Storyblok](https://www.storyblok.com/), a
headless CMS, to dynamically fetch and render content.

## SDK

This package contains an SDK for Storyblok Content Delivery API to fetch
stories, datasources, links etc.

It is designed to be used with the
[Code generator](https://pub.dev/packages/flutter_storyblok_code_generator) but
one can opt to not use it as well.

### Installation

```shell
flutter pub add flutter_storyblok
```

### Usage

```dart
// With Code generator
final storyblokClient = StoryblokClient(
  accessToken: "<public_access_token>",
  storyContentBuilder: (json) => Blok.fromJson(json),
);

// Without Code generator
final storyblokClient = StoryblokClient(
  accessToken: "<public_access_token>",
  storyContentBuilder: (json) => json,
);

final story = await storyblokClient.getStory(id: StoryIdentifierID(12345));

// ...

@override
Widget build(BuildContext context) {
  // With code generator, Exhaustiveness checking and automatic, type-safe, null-safe serializing.
  return switch (story.content) {
    DefaultPage page => Scaffold(
      appBar: AppBar(title: Text(story.name)),
      body: Center(child: Text(page.body)),
    ),
    UnrecognizedBlok _ => const Placeholder(),
  };

  // Without code generator, no Exhaustiveness checking, manual serializing.
  return switch (story.content["component"]) {
    "default-page" => Scaffold(
      appBar: AppBar(title: Text(story.name)),
      body: Center(child: Text(story.content["body"] is String ? story.content["body"] : "--")),
    ),
    _ => const Placeholder(),
  }
}
```

Check out the [Example](./example/) project for more advanced usage. The Example
project can be run as-is and will display Storyblok's standard Demo Space
project.

## API Documentation

Refer to the following Storyblok API documentation for more details:

- [Storyblok Content Delivery API V2 Reference](https://www.storyblok.com/docs/api/content-delivery/v2/)
- [Storyblok Management API Reference](https://www.storyblok.com/docs/api/management)
