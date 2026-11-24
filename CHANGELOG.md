# 1.5.0

Visual changes to `StoryblokRichText`:

- The base text style now comes from the nearest `DefaultTextStyle` instead of
  `Theme.of(context).textTheme.bodyMedium`. Directly inside a `Scaffold` body
  the style is unchanged, but in e.g. an `AppBar` or `ListTile` title it follows
  the surrounding text. Without a `Material` ancestor it gets Flutter's fallback
  style.
- Links and horizontal rules follow the ambient text color instead of always
  being black. Code uses black text on its light background.
- The widget is only as tall as its content instead of filling the available
  height, which can move it inside a parent that centers its child.

Fixes:

- Fixed memory leak of link tap recognizers in `StoryblokRichText`.
- Fixed static analysis issues and removed the dependency on Flutter's Material
  library.

# 1.4.0

Updated Dart SDK and dependency versions.

# 1.3.0

Added support for regions outside of EU

# 1.2.1

Bugfix for `StoryblokClient.getDataSourceEntries()`.

# 1.2.0

- Handles bug from Storyblok when copy-pasting rich-text in their visual editor
  causing color to change format and image meta_data to become "[object Object]"
  instead of a JSON object.
- Added `color` extension getter on rich text fore/backgroundColor.
- Renamed `HexColor` -> `StoryblokColor`.
- Renamed `colorHex` -> `colorString`.

# 1.1.0

- Separated StoryblokClient to its own client.dart export file and all the model
  exports into models.dart to fix dart:ui being imported when using the code
  generator.
- Renamed export file `flutter_storyblok.dart` -> `models.dart`.
- Moved `StoryblokClient` export file from `flutter_storyblok.dart` ->
  `client.dart`.

# 1.0.4

Added remaining properties on Story.

# 1.0.3+1

Updated README

# 1.0.3

Fix "Asset is abstract" error.

# 1.0.2

Docs comments.

# 1.0.1

Post publish fixes.

# 1.0.0

Initial release.
