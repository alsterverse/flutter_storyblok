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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: SearchBar(
            onSubmitted: _search,
            leading: const Icon(Icons.search),
            hintText: "Search a video",
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (results != null) ...[
            ...results.map((e) => Text(
                  e.videoTitle,
                  style: const TextStyle(color: Colors.white),
                )),
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
      results = stories.map((e) => e.content).cast<bloks.VideoPage>().toList();
    });
  }
}
