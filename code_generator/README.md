# Flutter Storyblok Code Generator

Uses Storybloks' [Management API](https://www.storyblok.com/docs/api/management)
to generate Dart classes from Blocks, Datasources etc.

## Getting Started

1. **Space ID:** Obtained from from Storyblok under `Settings` > `General` >
   `Space`.

2. **Personal Access Token:** Obtained from from Storyblok under `My Account` >
   `Security` > `Personal Access Token`.

## Installation

### Add to dev_dependencies

```shell
flutter pub add dev:flutter_storyblok_code_generator
```

## Running the Generator

Navigate to the project directory and run the following commands:

```shell
dart run flutter_storyblok_code_generator generate -s <space_id> -p <pat>
```

## Usage

### Script

```
Usage: flutter_storyblok_code_generator generate [arguments]
-h, --help                                 Print this usage information.
-s, --space_id (mandatory)                 Your Storyblok Space ID
-p, --personal_access_token (mandatory)    Your Personal Access Token, not your Space access token
-r, --rate_limit                           Your rate limit (depending on your plan)
                                           (defaults to "3")
-o, --output_path                          A directory path where the output file "bloks.generated.dart" will be created
                                           (defaults to "lib")
```

This will call the Management API multiple times to fetch all Blocks under
"Blocks Library", all Datasources and their entries, external datasources etc.
Make sure you set the rate limit correctly if you are on a
[plan other than Community](https://www.storyblok.com/docs/api/management/getting-started/rate-limit).

### Generated code

The script generates a file `bloks.generated.dart` which contains all internal
datasources, external datasources, blocks etc.

The datasources are generated as `enum` and their entries as enum values.

The blocks found in the Block library are generated as a `class` subclassed of
`sealed class Blok` for exhaustive checking when building the widgets to help
the developer handle all blocks and any future blocks.

When running the script after creating a new Block in the visual editor a new
`Blok` class will be generated causing the exhaustive checking to emit an error,
alerting the developer of what Widget needs implementation.

```dart
enum PageIcons {
  home,
  about,
  unknown;
}

sealed class Blok {
  factory Blok.fromJson(Map<String, dynamic> json);
}

final class Page extends Blok {
  final String title;
  final PageIcons icon;
  final List<Blok> body;
}
```

Because the `sealed class Blok` is being generated it is not available to the
SDK from a fresh start. To connect the generated blocks to the SDK,
`Blok.fromJson` factory method must be passed to `StoryblokClient`. This will
connect the generic constraint so that all `Story` objects returned by
`StoryblokClient` will have their `content` property as `Blok`.

## Features

The generator handles `component_whitelist` for all fields that use it e.g
`Blocks` by declaring the field as those whitelisted types with a new
`sealed class` for that specific field or if only one Block is whitelisted, it
declares the field as that Block e.g `Page`.

The generator also handles parameters such as `maximum` on Blocks and `decimals`
on Number by declaring the fields as either `List<Blok>` or just `Blok` and
either `double` or `int`.

## Building Widgets

When building the Widgets representing each block the developer have the freedom
to choose their preferred solution.

In the `Example` project the solution was to create an `extension on Blok` with
the function `Widget buildWidget(BuildContext)` which switches over itself and
with the aid of exhaustive checking creates each wiidget in a statically and
null-safe mannor.

```dart
extension BlockWidget on Blok {
  Widget buildWidget(BuildContext context) => switch (this) {
    final Page page => Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            switch (page.icon) {
              PageIcons.home => Icon(Icons.home),
              PageIcons.home => Icon(Icons.about),
              PageIcons.unknown => SizedBox.shrink(),
            },
            Text(page.title),
          ],
        ),
      ),
      body: Column(
        children: page.body.map((block) => block.buildWidget(context)).toList(),
      ),
    ),
    UnrecognizedBlock() => kDebugMode ? Placeholder() : SizedBox.shrink(),
  };
}
```

## App versions becoming old

Because an app is installed on a device it can grow old quickly. When a new
block is created in the Storyblok space the old app version wont know what the
new block is and therefore `UnrecognizedBlock` was created for such cases.

Datasources add the `unknown` value for this reason as well.

## Implementation status

- 🟢 = Fully implemented
- 🟡 = Implemented but missing some features
- ❌ = Not implemented

### Block fields

| Field         | Status | Notes                                         |
| :------------ | :----: | :-------------------------------------------- |
| Blocks        |   🟢   |                                               |
| Text          |   🟢   |                                               |
| TextArea      |   🟢   |                                               |
| RichText      |   🟢   |                                               |
| Markdown      |   🟢   |                                               |
| Number        |   🟢   |                                               |
| DateTime      |   🟢   |                                               |
| Boolean       |   🟢   |                                               |
| Single-Option |   🟡   | Source language is not generated into an enum |
| Multi-Options |   🟡   | Source language is not generated into an enum |
| Reference     |   🟡   | Same as Multi-options                         |
| Asset         |   🟢   |                                               |
| MultiAsset    |   🟢   |                                               |
| Link          |   🟢   |                                               |
| Table         |   🟢   |                                               |
| Plugin        |   🟢   |                                               |
| Group         |   ❌   | Only used in the visual editor                |
| Image (old)   |   ❌   | Deprecated                                    |
| File (old)    |   ❌   | Deprecated                                    |

### Datasources 🟡

- Does not generate dimensions

### Languages ❌

- TODO
