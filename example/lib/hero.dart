import 'package:example/bloks.generated.dart';
import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/link_type.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({
    super.key,
    required this.video,
  });

  final VideoItem video;

  @override
  Widget build(BuildContext context) {
    final bloks.VideoPage? linkedVideoPage = switch (video.videoLink) {
      LinkTypeURL() => null,
      final LinkTypeStory storyLink => storyLink.resolvedStory?.content as bloks.VideoPage?,
    };
    return GestureDetector(
      onTap: linkedVideoPage == null
          ? null
          : () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => linkedVideoPage.buildWidget(context),
              )),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: linkedVideoPage == null
                  ? null
                  : Image.network(
                      switch (linkedVideoPage.videoThumbnail) {
                        final LinkTypeURL urlLink => urlLink.url.toString(),
                        LinkTypeStory() => "",
                      },
                      fit: BoxFit.cover,
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextATV.subtitle(video.airDate.toString().split(" ")[0].toUpperCase()),
                  TextATV.hero(video.title.toString()),
                  TextATV.body(video.description.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
