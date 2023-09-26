import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/bottom_nav.dart';
import 'package:example/camera_screen.dart';
import 'package:example/carousel_block_widget.dart';
import 'package:example/hero.dart';
import 'package:example/primary_button.dart';
import 'package:example/utils.dart';
import 'package:example/video_item_widget.dart';
import 'package:example/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/story.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

final storyblokClient = StoryblokClient(
  accessToken: "2aurFHe7gdoL2yxIyk1APgtt",
  version: StoryblokVersion.draft,
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
        storyFuture: storyblokClient.getStory(id: const StoryIdentifierID(376648209)),
      );

      // return FutureBuilder(
      //   future: storyblokClient.getStories(startsWith: "bottomnavigationpages"),
      //   builder: (context, snapshot) {
      //     final stories = snapshot.data;
      //     if (stories != null) {
      //       return BottomNavigationPage(stories: stories);
      //     } else if (snapshot.hasError) {
      //       print(snapshot.error);
      //       print(snapshot.stackTrace);
      //       return Text(snapshot.error.toString());
      //     }
      //     return const Text("...");
      //   },
      // );
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
      ),
    );
  }
}

class FutureStoryWidget extends StatelessWidget {
  final Future<Story> storyFuture;
  const FutureStoryWidget({super.key, required this.storyFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storyFuture,
      builder: (context, snapshot) {
        final story = snapshot.data;
        if (story != null) {
          return Scaffold(
            body: bloks.Blok.fromJson(story.content).buildWidget(context),
            backgroundColor: Colors.black,
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

// TODO Generate resolver with lambdas for each blok
extension BlockWidget on bloks.Blok {
  Widget buildWidget(BuildContext context) {
    return switch (this) {
      final bloks.HardwareButton button => PrimaryButton(button.title,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CameraScreen(),
              ))),
      final bloks.Page page => Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: page.blocks?.map((e) => e.buildWidget(context)).toList() ?? [const Text("Empty")],
          ),
        ),
      final bloks.StartPage startPage => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: startPage.title == null
              ? null
              : AppBar(
                  backgroundColor: Colors.black,
                  elevation: 0,
                  title: const CircleAvatar(
                    backgroundColor: Colors.deepOrangeAccent,
                    child: Text(
                      "ATV",
                      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: startPage.content
                .map((e) {
                  final widget = e.buildWidget(context);
                  if (e is bloks.CarouselBlock) return widget;
                  return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: widget);
                })
                .separatedBy(() => const SizedBox(height: 20))
                .toList(),
          ),
        ),
      final bloks.TestBlock testBlock => Text("TestBlock: ${testBlock.text2}"),
      final bloks.VideoItem videoItem => VideoItemWidget(videoItem: videoItem),
      final bloks.VideoPage videoPage => VideoPageWidget(videoPage: videoPage),
      final bloks.CarouselBlock carouselBlock => CarouselBlockWidget(carouselBlock: carouselBlock),
      final bloks.TextBlock textBlock => Text(textBlock.body ?? "-"),
      final bloks.BottomNavigation bottomNav => BottomNavigation(bottomNav: bottomNav),
      final bloks.Hero hero => HeroWidget(video: hero.video as bloks.VideoItem),
      final bloks.BottomNavPage bottomNavPage => BottomNavigationPage(bottomNavPage: bottomNavPage),
      final bloks.SearchPage searchPage => SearchPage(searchPage: searchPage),
      _ => const SizedBox.shrink(), // TODO Remove
    };
  }
}

class BottomNavigationPage extends StatelessWidget {
  final bloks.BottomNavPage bottomNavPage;
  const BottomNavigationPage({super.key, required this.bottomNavPage});

  @override
  Widget build(BuildContext context) {
    return bottomNavPage.block.buildWidget(context);
  }
}

class SearchPage extends StatelessWidget {
  final bloks.SearchPage searchPage;
  const SearchPage({super.key, required this.searchPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Search...")),
    );
  }
}
