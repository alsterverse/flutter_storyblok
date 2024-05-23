import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class ArticleOverviewPageScreen extends StatelessWidget {
  const ArticleOverviewPageScreen(this.blok, {super.key});

  final bloks.ArticleOverviewPage blok;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blok.headline ?? ""),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: storyblokClient.getStories(startsWith: "articles/", isStartpage: false),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 64),
                child: CircularProgressIndicator(),
              ));
            }

            final data = snapshot.data?.map((story) => story.content as bloks.ArticlePage).toList();

            if (data == null) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Whoops..! No articles found :(",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ));
            }
            return Column(
              children: [
                ...data.map<Widget>((article) {
                  final articleImage = article.image?.buildNetworkImage();
                  return Container(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (articleImage != null) articleImage,
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.headline ?? "",
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    article.teaser ?? "",
                                  ),
                                  const SizedBox(height: 32),
                                  TextButton(
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Read more",
                                        ),
                                        Icon(Icons.arrow_forward)
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: article.buildWidget));
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                })
              ],
            );
          },
        ),
      ),
    );
  }
}
