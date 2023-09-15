import 'package:example/story_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';
import 'package:flutter_storyblok/story.dart';
import 'package:flutter_storyblok/serializer.dart';
import 'package:flutter_storyblok/reflector.dart';
import 'main.reflectable.dart';

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
  },
  reflector,
);

void main() {
  initializeReflectable();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: storyblokClient.getStories("bottomnavigationpages"),
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
