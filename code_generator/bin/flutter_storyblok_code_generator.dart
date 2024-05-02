import 'dart:io';

import '../lib/http_client.dart';
import '../lib/generator.dart';

void main(List<String> args) async {
  final spaceId = args[0];
  final authorization = args[1];
  final outputPath = args[2];

  final _apiClient = StoryblokHttpClient(spaceId, authorization);
  final datasourcesWithEntriesFuture = _apiClient.getDatasourcesWithEntries();
  final componentsFuture = _apiClient.getComponents();

  final codegen = StoryblokCodegen(
    datasourceWithEntries: await datasourcesWithEntriesFuture,
    components: await componentsFuture,
  );

  final code = await codegen.generate();
  final file = File(outputPath);
  if (await file.exists()) await file.delete();
  await file.writeAsString(code);
}
