import 'dart:async';

import 'package:example/accelerometer_screen.dart';
import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/bottom_nav.dart';
import 'package:example/camera_screen.dart';
import 'package:example/carousel_block_widget.dart';
import 'package:example/components/colors.dart';
import 'package:example/hero.dart';
import 'package:example/components/block_button.dart';
import 'package:example/image_block_widget.dart';
import 'package:example/rich_text_content.dart';
import 'package:example/search_page.dart';
import 'package:example/splash_screen.dart';
import 'package:example/start_page.dart';
import 'package:example/video_block_widget.dart';
import 'package:example/video_item_widget.dart';
import 'package:example/video_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart' as sb;
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:example/starter_blocks/teaser.dart';
import 'package:example/starter_blocks/feature.dart';
import 'package:example/starter_blocks/grid.dart';
import 'package:example/starter_blocks/page.dart' as starter_blocks;
import 'package:collection/collection.dart';

const rootPageId = 381723347;
final storyblokClient = sb.StoryblokClient<bloks.Blok>(
  accessToken: "w6ZsTA1a0xxlQpd7Kkeqjgtt",
  version: sb.StoryblokVersion.draft,
  contentBuilder: (json) => bloks.Blok.fromJson(json),
);

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

final router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) {
      final slug = state.uri.queryParameters["slug"];

      if (slug != null) {
        return FutureStoryWidget(
          storyFuture: storyblokClient.getStory(id: sb.StoryIdentifierFullSlug(slug)),
        );
      }

      return FutureStoryWidget(
        storyFuture: storyblokClient.getStory(id: const sb.StoryIdentifierID(rootPageId)),
        delayed: true,
      );
    },
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter x Storyblok',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
        ),
      ),
    );
  }
}

class FutureStoryWidget extends StatelessWidget {
  final Future<sb.Story<bloks.Blok>> storyFuture;
  final bool delayed;
  const FutureStoryWidget({
    super.key,
    required this.storyFuture,
    this.delayed = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        storyFuture,
        if (delayed) Future.delayed(const Duration(milliseconds: 2500)),
      ]),
      builder: (context, snapshot) {
        final story = snapshot.data?.first as sb.Story<bloks.Blok>?;
        if (story != null) {
          return Scaffold(
            body: story.content.buildWidget(context),
            backgroundColor: AppColors.black,
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }
        return const Scaffold(
          body: SplashScreen(),
        );
      },
    );
  }
}

// TODO Generate resolver with lambdas for each blok
extension BlockWidget on bloks.Blok {
  Widget buildWidget(BuildContext context) {
    return switch (this) {
      final bloks.HardwareButton button => BlockButton(
          button.title,
          onPressed: () => switch (button.sensor) {
            bloks.PhoneHardware.camera =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CameraScreen())),
            bloks.PhoneHardware.accelerometer =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AccelerometerScreen())),
            bloks.PhoneHardware.vibration => HapticFeedback.vibrate(),
            bloks.PhoneHardware.unknown => print("Unrecognized tap action"),
          },
        ),
      final bloks.StartPage startPage => StartPage(startPage: startPage),
      final bloks.VideoItem videoItem => VideoItemWidget.fromVideoItem(videoItem),
      final bloks.VideoPage videoPage => VideoPageWidget(videoPage: videoPage),
      final bloks.CarouselBlock carouselBlock => CarouselBlockWidget(carouselBlock: carouselBlock),
      final bloks.TextBlock textBlock => Text(textBlock.body ?? "-"),
      final bloks.BottomNavigation bottomNav => BottomNavigation(bottomNav: bottomNav),
      final bloks.Hero hero => HeroWidget(videoItem: hero.video),
      final bloks.SearchPage searchPage => SearchPage(searchPage: searchPage),
      final bloks.ImageBlock imageBlock => ImageBlockWidget(imageBlock: imageBlock),
      final bloks.VideoBlock videoBlock => VideoBlockWidget(videoBlock: videoBlock),
      final bloks.Feature feature => Feature(name: feature.name),
      final bloks.Teaser teaser => Teaser(headline: teaser.headline),
      final bloks.Page page => starter_blocks.Page(page: page),
      final bloks.Grid _ => const Grid(),
      final bloks.RichBlock rich => StoryblokRichTextContent(
          content: rich.richTextHeader?.content ?? [],
          onTapLink: (link) => switch (link) {
            sb.LinkTypeURL() => print("Open URL: ${link.url}"),
            sb.LinkTypeAsset() => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(),
                  body: Center(
                    child: Image.network(link.url.toString()),
                  ),
                ),
              )),
            sb.LinkTypeEmail() => print("Send email to: ${link.email}"),
            sb.LinkTypeStory() => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FutureStoryWidget(
                    storyFuture: storyblokClient.getStory(id: sb.StoryIdentifierUUID(link.uuid)),
                  ),
                ),
              ),
          },
        ),
      final bloks.TestBlock test => StoryblokRichTextContent(content: test.richtext2.content),
      final bloks.TestTable table => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: table.defaultTable.columns
                  .map((column) => Expanded(
                        child: Column(
                          children: column
                              .mapIndexed((i, e) => Text(
                                    e,
                                    style: TextStyle(fontWeight: i != 0 ? null : FontWeight.bold),
                                  ))
                              .toList(),
                        ),
                      ))
                  .toList(),
            ),
            Table(
              children: table.defaultTable.rows
                  .mapIndexed((i, e) => TableRow(
                        children: e
                            .map((e) => Text(
                                  e,
                                  style: TextStyle(fontWeight: i != 0 ? null : FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ))
                            .toList(),
                      ))
                  .toList(),
            ),
          ],
        ),
      final bloks.TestMultiOptions multi => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Default: ${multi.default$.map((e) => "${e.name}: '${e.raw}'").join(", ")}"),
            Text("Stories: ${multi.stories.map((e) => e.uuid).join(", ")}"),
            Text("Languages: ${multi.languages.map((e) => e).join(", ")}"),
            Text("Datasource: ${multi.datasource.map((e) => "${e.name}: '${e.raw}'").join(", ")}"),
            Text("External: ${multi.external$.map((e) => e).join(", ")}"),
          ],
        ),
      final bloks.TestPlugin plugin => Text(plugin.plugin?.data.toString() ?? ""),
      //TODO: remove this line before release
      _ => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
    };
  }
}
