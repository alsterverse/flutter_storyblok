import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
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
        title: TextATV.carouselHeading("Hej"),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: ShapeDecoration(
                  shape: StadiumBorder(
                    side: BorderSide(
                      width: 1,
                      color: AppColors.white.withOpacity(
                        0.1,
                      ),
                    ),
                  ),
                  color: AppColors.layer,
                ),
                height: 56,
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.search,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        style: bodyStyle.copyWith(color: AppColors.white),
                        onSubmitted: _search,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Search for video', hintStyle: TextStyle(color: AppColors.white)),
                        autocorrect: false,
                      ),
                    )
                  ],
                ),
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
