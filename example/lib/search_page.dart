import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
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
        title: TextATV.carouselHeading(widget.searchPage.header.toUpperCase()),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SearchBar(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 41, 41, 41)),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16)),
                onSubmitted: _search,
                leading: const Icon(
                  Icons.search,
                  color: AppColors.white,
                ),
                hintText: "Search a video",
                textStyle: MaterialStateTextStyle.resolveWith((states) => bodyStyle.copyWith(color: AppColors.white))),
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
      results = List<bloks.VideoPage>.from(stories.map((e) => bloks.Blok.fromJson(e.content)));
    });
  }
}
