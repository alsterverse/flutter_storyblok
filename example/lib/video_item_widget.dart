import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/link_type.dart';

class VideoItemWidget extends StatelessWidget {
  final bloks.VideoItem videoItem;
  const VideoItemWidget({super.key, required this.videoItem});

  @override
  Widget build(BuildContext context) {
    final linkedVideoPage =
        (bloks.Blok.fromJson((videoItem.videoLink as LinkTypeStory).resolvedStory!.content) as bloks.VideoPage);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => linkedVideoPage.buildWidget(context)),
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade800),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                (linkedVideoPage.videoThumbnail as LinkTypeURL).url.toString(),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              linkedVideoPage.videoTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              videoItem.summary ?? linkedVideoPage.videoDescription,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
