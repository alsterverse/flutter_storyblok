import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/main.dart';
import 'package:example/video_item_widget.dart';
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
            child: Container(
              decoration: const ShapeDecoration(shape: StadiumBorder(), color: Colors.white),
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  const Icon(Icons.search),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onSubmitted: _search,
                      decoration: const InputDecoration.collapsed(hintText: 'Search for video'),
                      autocorrect: false,
                    ),
                  )
                ],
              ),
            )),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (results != null) ...[
            ...results.map((e) => VideoItemWidget.fromVideoPage(e)),
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
    final stories = await storyblokClient.getStories(startsWith: "videos/", searchTerm: query);
    print(stories.map((e) => e.name).toList().join(", "));
    setState(() {
      results = stories.map((e) => e.content).cast<bloks.VideoPage>().toList();
    });
  }
}
