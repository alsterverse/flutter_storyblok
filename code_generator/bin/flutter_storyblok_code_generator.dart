import 'dart:io';

import 'package:flutter_storyblok_code_generator/flutter_storyblok_code_generator.dart';

void main(List<String> args) async {
  final spaceId = args[0];
  final authorization = args[1];
  final outputPath = args[2];

  final apiClient = StoryblokHttpClient(spaceId, authorization);
  final datasourcesWithEntriesFuture = apiClient.getDatasourcesWithEntries();
  final componentsFuture = apiClient.getComponents();

  final codegen = StoryblokCodegen(
    datasourceWithEntries: await datasourcesWithEntriesFuture,
    components: await componentsFuture,
  );

  final code = await codegen.generate();
  final file = File(outputPath);
  if (await file.exists()) await file.delete();
  await file.writeAsString(code);
}
