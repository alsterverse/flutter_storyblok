# Flutter Storyblok Code Generator

Uses Storybloks' [Management API](https://www.storyblok.com/docs/api/management)
to generate Dart classes from Blocks, Datasources etc.

## Getting Started

1. **Space ID:** Obtained from from Storyblok under `Settings` > `General` >
   `Space`.

2. **Personal Access Token:** Obtained from from Storyblok under `My Account` >
   `Security` > `Personal Access Token`.

## Running the Generator

Navigate to the project directory and run the following commands:

```shell
dart run flutter_storyblok_code_generator \
  <space_id> \
  <personal_access_token> \
  <output_destination>
```

This will call the Management API multiple times to fetch all Blocks under
"Blocks Library", all Datasources and their entries, external datasources etc.

> Rate limit set to 3/s.
