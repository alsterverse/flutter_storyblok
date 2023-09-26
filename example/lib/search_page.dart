import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/main.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final bloks.SearchPage searchPage;
  const SearchPage({super.key, required this.searchPage});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<bloks.VideoPage>? results;

  @override
  Widget build(BuildContext context) {
    final results = this.results;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchPage.header),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SearchBar(
            onSubmitted: _search,
            leading: Icon(Icons.search),
          ),
          if (results != null) ...[
            const SizedBox(height: 40),
            ...results.map((e) => Text(e.videoTitle)),
          ],
        ],
      ),
    );
  }

  Future _search(String query) async {
    query = query.trim();
    if (query.isEmpty) {
      setState(() {
        results = null;
      });
      return;
    }
    print("Search for: '$query'");
    final stories = await storyblokClient.getStories(startsWith: query);
    print(stories.map((e) => e.name).toList().join(", "));
    setState(() {
      results = List<bloks.VideoPage>.from(stories.map((e) => bloks.Blok.fromJson(e.content)));
    });
  }
}