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
    final linkedVideoPage =
        (bloks.Blok.fromJson((video.videoLink as LinkTypeStory).resolvedStory!.content) as bloks.VideoPage);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => linkedVideoPage.buildWidget(context)),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
                colors: [Color.fromARGB(94, 140, 2, 215), Color.fromARGB(211, 0, 110, 255)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  ((bloks.Blok.fromJson((video.videoLink as LinkTypeStory).resolvedStory!.content) as bloks.VideoPage)
                          .videoThumbnail as LinkTypeURL)
                      .url
                      .toString(),
                  fit: BoxFit.cover,
                )),
            // "https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg")),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.airDate.toString().split(" ")[0].toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.white.withOpacity(0.6),
                          fontSize: 12,
                          height: 1.2)),
                  const SizedBox(
                    height: 4,
                  ),
                  TextATV.hero(
                    video.title.toString(),
                    // style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextATV.body(video.description.toString(), color: AppColors.white.withOpacity(0.8)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
