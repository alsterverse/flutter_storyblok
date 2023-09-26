import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/link_type.dart';

class VideoItemWidget extends StatelessWidget {
  final Uri thumbnailUrl;
  final String title;
  final String? description;
  final WidgetBuilder videoPageBuilder;

  const VideoItemWidget(
      {super.key,
      required this.thumbnailUrl,
      required this.title,
      required this.description,
      required this.videoPageBuilder});

  factory VideoItemWidget.fromVideoItem(bloks.VideoItem videoItem, [bool small = false]) {
    final linkedVideoPage =
        (bloks.Blok.fromJson((videoItem.videoLink as LinkTypeStory).resolvedStory!.content) as bloks.VideoPage);
    return VideoItemWidget(
      thumbnailUrl: (linkedVideoPage.videoThumbnail as LinkTypeURL).url,
      title: (videoItem.title != null && videoItem.title!.isNotEmpty) ? videoItem.title! : linkedVideoPage.videoTitle,
      description: small
          ? null
          : videoItem.description != null && videoItem.description!.isNotEmpty
              ? videoItem.description!
              : linkedVideoPage.videoDescription,
      videoPageBuilder: (context) => linkedVideoPage.buildWidget(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: videoPageBuilder),
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade800),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(thumbnailUrl.toString(), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            if (description != null)
              Text(
                description!,
                style: const TextStyle(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
