import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_storyblok/models.dart' as sb;
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
  static const _optionSpaceId = "space_id";
  static const _optionPAT = "personal_access_token";
  static const _optionLocation = "space_location";
  static const _optionRateLimit = "rate_limit";
  static const _nameOutputPath = "output_path";
  static const _outPutFileName = "bloks.generated.dart";

  GenerateCommand() {
    argParser.addOption(
      _optionSpaceId,
      abbr: "s",
      help: "Your Storyblok Space ID",
      mandatory: true,
    );
    argParser.addOption(
      _optionPAT,
      abbr: "p",
      help: "Your Personal Access Token, not your Space access token",
      mandatory: true,
    );
    argParser.addOption(
      _optionLocation,
      abbr: "l",
      help: "The server location of the space",
      mandatory: false,
      allowed: sb.Region.values.map((e) => e.name),
      defaultsTo: sb.Region.eu.name,
    );
    argParser.addOption(
      _optionRateLimit,
      abbr: "r",
      help: "Your rate limit (depending on your plan)",
      mandatory: false,
      defaultsTo: "3",
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
    final spaceId = results[_optionSpaceId] as String;
    final pat = results[_optionPAT] as String;
    final rateLimit = results[_optionRateLimit] as String;
    final outputPath = results[_nameOutputPath] as String;
    final region = results[_optionLocation] as String;

    final apiClient = StoryblokHttpClient(spaceId, pat, sb.Region.values.byName(region), int.parse(rateLimit));
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
