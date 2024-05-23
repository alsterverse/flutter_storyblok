import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class FeaturedArticlesSectionWidget extends StatelessWidget {
  const FeaturedArticlesSectionWidget(this.blok, {super.key});

  final bloks.FeaturedArticlesSection blok;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: blok.backgroundColor == bloks.BackgroundColors.white ? const EdgeInsets.only(top: 32) : null,
      color: switch (blok.backgroundColor) {
        bloks.BackgroundColors.light => AppColors.background,
        bloks.BackgroundColors.white => AppColors.white,
        bloks.BackgroundColors.unknown => AppColors.white
      },
      child: Column(
        children: [
          Text(blok.headline ?? "", style: Theme.of(context).textTheme.headlineLarge),
          if (blok.lead != null || blok.lead!.isNotEmpty)
            Text(blok.lead!, style: Theme.of(context).textTheme.headlineSmall),
          ...blok.articles
              .map<Widget>(
                (articleId) => FutureBuilder(
                  key: ValueKey(articleId),
                  future: storyblokClient.getStory(id: articleId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final article = snapshot.data!.content as bloks.ArticlePage;

                    final backgroundColor = switch (blok.backgroundColor) {
                      bloks.BackgroundColors.white => AppColors.background,
                      bloks.BackgroundColors.light => AppColors.white,
                      bloks.BackgroundColors.unknown => AppColors.background,
                    };

                    final articleImage = article.image?.buildNetworkImage();

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: article.buildWidget));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            color: backgroundColor,
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
                        ),
                      ),
                    );
                  },
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
