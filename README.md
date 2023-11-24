# Flutter Storyblok README

This Flutter project integrates with Storyblok, a headless CMS, to dynamically
fetch and render content. Follow the instructions below to set up and run the
project.

## Prerequisites

- Dart SDK
- Flutter SDK

## Getting Started

1. **Personal Access Token:** Obtain your Personal Access Token from Storyblok.
   You can find it under `My Account` > `Security` > `Personal Access Token`.

2. **Space ID:** Find your Space ID in Storyblok under `Settings` > `General` >
   `Space`.

## Running the Generator

Navigate to the project directory and run the following commands:

```bash
cd flutter_storyblok
dart run bin/storyblok_sourcegen.dart [SPACE ID] [ACCESS TOKEN] "example/lib/bloks.generated.dart"
```

Replace `[SPACE ID]` and `[ACCESS TOKEN]` with your Storyblok Space ID and
Personal Access Token.

## Project Structure

The project utilizes a Dart SDK to fetch Storyblok components. A source
generator is used to create Dart classes that parse these Bloks as JSON. The
generated Bloks can then be utilized by a Flutter app to dynamically generate a
page based on a Storyblok Story.

## Preview

A preview of the content from Storyblok is available within the Storyblok
interface. Additionally, there is a Flutter web preview hosted on Nettify.

## API Documentation

Refer to the following Storyblok API documentation for more details:

- [Storyblok Content Delivery API V2 Reference](https://www.storyblok.com/docs/api/content-delivery)
- [Storyblok Management API Reference](https://www.storyblok.com/docs/api/management)

Feel free to explore these resources for a deeper understanding of the
integration and customization options.
