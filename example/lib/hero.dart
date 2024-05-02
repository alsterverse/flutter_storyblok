import 'package:example/bloks.generated.dart';
import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/link.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({
    super.key,
    required this.videoItem,
  });

  final VideoItem videoItem;

  @override
  Widget build(BuildContext context) {
    final bloks.VideoPage? linkedVideoPage = switch (videoItem.videoLink) {
      LinkTypeURL() => null,
      final LinkTypeStory storyLink => storyLink.resolvedStory?.content as bloks.VideoPage?,
    };
    final title = videoItem.title;
    final description = videoItem.description;
    return GestureDetector(
      onTap: linkedVideoPage == null
          ? null
          : () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => linkedVideoPage.buildWidget(context),
              )),
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
                  Text(videoItem.airDate.toString().split(" ")[0].toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.white.withOpacity(0.6),
                          fontSize: 12,
                          height: 1.2)),
                  const SizedBox(height: 4),
                  TextATV.hero(title != null && title.isNotEmpty ? title : (linkedVideoPage?.videoTitle).toString()),
                  const SizedBox(height: 4),
                  TextATV.body(
                    description != null && description.isNotEmpty
                        ? description
                        : (linkedVideoPage?.videoDescription).toString(),
                    color: AppColors.white.withOpacity(0.8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
