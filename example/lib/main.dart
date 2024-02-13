import 'dart:async';

import 'package:example/accelerometer_screen.dart';
import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/bottom_nav.dart';
import 'package:example/camera_screen.dart';
import 'package:example/carousel_block_widget.dart';
import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:example/hero.dart';
import 'package:example/components/block_button.dart';
import 'package:example/image_block_widget.dart';
import 'package:example/search_page.dart';
import 'package:example/splash_screen.dart';
import 'package:example/start_page.dart';
import 'package:example/utils.dart';
import 'package:example/video_block_widget.dart';
import 'package:example/video_item_widget.dart';
import 'package:example/video_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/story.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:example/starter_components/teaser.dart';
import 'package:example/starter_components/feature.dart';
import 'package:example/starter_components/grid.dart';

const rootPageId = 381723347;
final storyblokClient = StoryblokClient<bloks.Blok>(
  accessToken: "w6ZsTA1a0xxlQpd7Kkeqjgtt",
  version: StoryblokVersion.draft,
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
          storyFuture: storyblokClient.getStory(id: StoryIdentifierFullSlug(slug)),
        );
      }

      return FutureStoryWidget(
        storyFuture: storyblokClient.getStory(id: const StoryIdentifierID(rootPageId)),
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
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class FutureStoryWidget extends StatelessWidget {
  final Future<Story<bloks.Blok>> storyFuture;
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
        final story = snapshot.data?.first as Story<bloks.Blok>?;
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
      final bloks.HardwareButton button => BlockButton(button.title,
          onPressed: () => switch (button.sensor) {
                bloks.PhoneHardware.camera =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CameraScreen())),
                bloks.PhoneHardware.accelerometer =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AccelerometerScreen())),
                bloks.PhoneHardware.vibration => HapticFeedback.vibrate(),
                bloks.PhoneHardware.unknown => print("Unrecognized tap action"),
              }),
      final bloks.Page page => Scaffold(
          appBar: AppBar(title: TextATV.carouselHeading("Blocks".toUpperCase())),
          body: Center(
            child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(24),
                children: page.body
                    .map((e) => e.buildWidget(context))
                    .separatedBy(() => const SizedBox(height: 24))
                    .toList()),
          ),
        ),
      final bloks.StartPage startPage => StartPage(startPage: startPage),
      final bloks.TestBlock testBlock => Text("TestBlock: ${testBlock.text2}"),
      final bloks.VideoItem videoItem => VideoItemWidget.fromVideoItem(videoItem),
      final bloks.VideoPage videoPage => VideoPageWidget(videoPage: videoPage),
      final bloks.CarouselBlock carouselBlock => CarouselBlockWidget(carouselBlock: carouselBlock),
      final bloks.TextBlock textBlock => Text(textBlock.body ?? "-"),
      final bloks.BottomNavigation bottomNav => BottomNavigation(bottomNav: bottomNav),
      final bloks.Hero hero => HeroWidget(videoItem: hero.video),
      final bloks.BottomNavPage bottomNavPage => BottomNavigationPage(bottomNavPage: bottomNavPage),
      final bloks.SearchPage searchPage => SearchPage(searchPage: searchPage),
      final bloks.ImageBlock imageBlock => ImageBlockWidget(imageBlock: imageBlock),
      final bloks.VideoBlock videoBlock => VideoBlockWidget(videoBlock: videoBlock),
      final bloks.Feature featureBlock => Feature(name: featureBlock.name),
      final bloks.Teaser teaserBlock => Teaser(headline: teaserBlock.headline),
      final bloks.Grid gridBlock => Grid(),
      bloks.UnrecognizedBlok() => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
//TODO: remove this line before release
      // _ => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
      // TODO: Handle this case.
      bloks.ContentEditor() => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
      // TODO: Handle this case.
      bloks.MultiOptionsBlock() => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
      // TODO: Handle this case.
      bloks.MultiPage() => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
      // TODO: Handle this case.
      bloks.Rich() => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
      // TODO: Handle this case.
      bloks.Root() => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
      // TODO: Handle this case.
      bloks.Testar() => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
      // TODO: Handle this case.
      bloks.TestMultiAssetsBlock() => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
      // final bloks.TestMultiAssetsBlock multiAssatBlock => MultiAssatWidget(multiAssatBlock: multiAssatBlock),
      // TODO: Handle this case.
      bloks.BottomNavigationItem() => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
    };
  }
}
