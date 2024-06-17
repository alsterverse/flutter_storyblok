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
dart run flutter_storyblok_code_generator generate -s <space_id> -p <pat>
```

### Usage

```
Usage: flutter_storyblok_code_generator generate [arguments]
-h, --help                                 Print this usage information.
-s, --space_id (mandatory)                 Your Storyblok Space ID
-p, --personal_access_token (mandatory)    Your Personal Access Token, not your Space access token
-o, --output_path                          A directory path where the output file "bloks.generated.dart" will be created
                                           (defaults to "lib")
```

This will call the Management API multiple times to fetch all Blocks under
"Blocks Library", all Datasources and their entries, external datasources etc.

> Rate limit set to 3/s.
