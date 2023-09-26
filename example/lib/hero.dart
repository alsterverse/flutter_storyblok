import 'package:example/bloks.generated.dart';
import 'package:example/bloks.generated.dart' as bloks;
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
        decoration: BoxDecoration(color: Colors.deepPurpleAccent.withOpacity(.25)),
        child: Column(
          children: [
            // Image.network(video.videoLink.toString()),
            Image.network("https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg"),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.airDate.toString().split(" ")[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  Text(
                    video.title.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    video.description.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
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
