import 'package:example/story_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/story.dart';
import 'package:flutter_storyblok/serializer.dart';
import 'package:flutter_storyblok/reflector.dart';
import 'package:go_router/go_router.dart';
import 'main.reflectable.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

final storyblokClient = StoryblokClient(
  accessToken: "cLvisb6uENGw0BOhOOx0wQtt",
  version: StoryblokVersion.draft,
);
final storyblokSerializer = StoryblokWidgetSerializer(
  const {
    TypeSerializable(ArticleListPage, ArticleListPage.fromJson),
    TypeSerializable(ArticlePage, ArticlePage.fromJson),
    TypeSerializable(StoryblokColumn, StoryblokColumn.fromJson),
    TypeSerializable(StoryblokRow, StoryblokRow.fromJson),
    TypeSerializable(StoryblokText, StoryblokText.fromJson),
    TypeSerializable(StoryblokImage, StoryblokImage.fromJson),
    TypeSerializable(ArticleItem, ArticleItem.fromJson),
    TypeSerializable(StoryblokFlex, StoryblokFlex.fromJson),
  },
  reflector,
);

void main() {
  initializeReflectable();
  usePathUrlStrategy();
  runApp(const MyApp());
}

final router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) {
      final slug = state.uri.queryParameters["slug"];

      if (slug != null) {
        return FutureBuilder(
          future: storyblokClient.getStory(StoryIdentifierFullSlug(slug)),
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data != null) {
              return storyblokSerializer.serializeJson(data.content).buildWidget(context);
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              print(snapshot.stackTrace);
            }
            return Text("...");
          },
        );
      }

      return FutureBuilder(
        future: storyblokClient.getStories(startsWith: "bottomnavigationpages"),
        builder: (context, snapshot) {
          final stories = snapshot.data;
          if (stories != null) {
            return BottomNavigationPage(stories: stories);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            print(snapshot.stackTrace);
            return Text(snapshot.error.toString());
          }
          return const Text("...");
        },
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class BottomNavigationPage extends StatefulWidget {
  final List<Story> stories;
  const BottomNavigationPage({super.key, required this.stories});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.lightBlue,
        onTap: (value) => _onTap(value),
        items: widget.stories
            .map((story) => BottomNavigationBarItem(
                  icon: const Icon(Icons.abc),
                  label: story.name,
                ))
            .toList(),
        currentIndex: _selectedIndex,
      ),
      body: IndexedStack(
          index: _selectedIndex,
          children: widget.stories
              .map(
                (e) => storyblokSerializer.serializeJson(e.content).buildWidget(context),
              )
              .toList()),
    );
  }
}
