import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/camera_screen.dart';
import 'package:example/primary_button.dart';
import 'package:example/utils.dart';
import 'package:example/video_item_widget.dart';
import 'package:example/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/story.dart';
import 'package:go_router/go_router.dart';
// import 'main.reflectable.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

final storyblokClient = StoryblokClient(
  accessToken: "2aurFHe7gdoL2yxIyk1APgtt",
  version: StoryblokVersion.draft,
);
// final storyblokSerializer = StoryblokWidgetSerializer(
//   const {
//     TypeSerializable(ArticleListPage, ArticleListPage.fromJson),
//     TypeSerializable(ArticlePage, ArticlePage.fromJson),
//     TypeSerializable(StoryblokColumn, StoryblokColumn.fromJson),
//     TypeSerializable(StoryblokRow, StoryblokRow.fromJson),
//     TypeSerializable(StoryblokText, StoryblokText.fromJson),
//     TypeSerializable(StoryblokImage, StoryblokImage.fromJson),
//     TypeSerializable(ArticleItem, ArticleItem.fromJson),
//     TypeSerializable(StoryblokFlex, StoryblokFlex.fromJson),
//     TypeSerializable(StoryblokIconButton, StoryblokIconButton.fromJson),
//   },
//   reflector,
// );

void main() {
  // initializeReflectable();
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
        storyFuture: storyblokClient.getStory(id: const StoryIdentifierID(374000037)),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
          return bloks.Blok.fromJson(story.content).buildWidget(context);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }
        return const Scaffold(body: Center(child: Text("Loading...")));
      },
    );
  }
}

// TODO Generate resolver with lambdas for each blok
extension BlockWidget on bloks.Blok {
  Widget buildWidget(BuildContext context) {
    return switch (this) {
      final bloks.Hero _ => Container(color: Colors.red, height: 200),
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
          appBar: startPage.title == null
              ? null
              : AppBar(
                  title: Text(startPage.title!),
                ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: startPage.content
                .map((e) => e.buildWidget(context))
                .separatedBy(() => const SizedBox(height: 20))
                .toList(),
          ),
        ),
      final bloks.TestBlock testBlock => Text("TestBlock: ${testBlock.text2}"),
      final bloks.VideoItem videoItem => VideoItemWidget(videoItem: videoItem),
      final bloks.VideoPage videoPage => VideoPageWidget(videoPage: videoPage),
      _ => const SizedBox.shrink(), // TODO Remove
    };
  }
}
