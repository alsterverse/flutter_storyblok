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
