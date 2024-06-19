import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_storyblok_code_generator/flutter_storyblok_code_generator.dart';
import 'package:flutter_storyblok_code_generator/src/utils/utils.dart';

void main(List<String> args) async {
  final runner = CommandRunner("flutter_storyblok_code_generator", "Code generator for flutter_storyblok");
  final generateCommand = GenerateCommand();
  runner.addCommand(generateCommand);
  try {
    await runner.run(args);
  } catch (ex) {
    print("");
    if (ex is ArgumentError) {
      print("");
      generateCommand.printUsage();
      exit(64);
    }
    if (ex is! UsageException) rethrow;
    print(ex);
  }
}

class GenerateCommand extends Command {
  static const _nameSpaceId = "space_id";
  static const _namePAT = "personal_access_token";
  static const _nameOutputPath = "output_path";
  static const _outPutFileName = "bloks.generated.dart";

  GenerateCommand() {
    argParser.addOption(
      _nameSpaceId,
      abbr: "s",
      help: "Your Storyblok Space ID",
      mandatory: true,
    );
    argParser.addOption(
      _namePAT,
      abbr: "p",
      help: "Your Personal Access Token, not your Space access token",
      mandatory: true,
    );
    argParser.addOption(
      _nameOutputPath,
      abbr: "o",
      help: "A directory path where the output file \"$_outPutFileName\" will be created",
      mandatory: false,
      defaultsTo: "lib",
    );
  }

  @override
  final String name = "generate";
  @override
  final String description = "Generate the Storyblok blocks into Dart classes";

  final Map<Uri, List<JSONMap>> _externalDatasourceCache = {};

  @override
  FutureOr? run() async {
    final results = argResults!;
    final spaceId = results[_nameSpaceId] as String;
    final pat = results[_namePAT] as String;
    final outputPath = results[_nameOutputPath] as String;

    final apiClient = StoryblokHttpClient(spaceId, pat);
    final datasourcesWithEntriesFuture = apiClient.getDatasourcesWithEntries();
    final componentsFuture = apiClient.getComponents();

    final codegen = StoryblokCodegen(
      components: await componentsFuture,
      datasourceWithEntries: await datasourcesWithEntriesFuture,
      getExternalDatasourceEntries: (url) async {
        final cached = _externalDatasourceCache[url];
        if (cached != null) return cached;
        final data = await apiClient.getExternalDatasourceEntries(url);
        _externalDatasourceCache[url] = data;
        return data;
      },
    );

    final code = await codegen.generate();
    final file = File("$outputPath/$_outPutFileName");
    if (await file.exists()) await file.delete();
    await file.create(recursive: true);
    await file.writeAsString(code);
  }
}
