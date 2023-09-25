import 'package:example/bloks.generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/link_type.dart';
import 'package:video_player/video_player.dart';

class VideoPageWidget extends StatefulWidget {
  final VideoPage videoPage;
  const VideoPageWidget({super.key, required this.videoPage});

  @override
  State<VideoPageWidget> createState() => _VideoPageWidgetState();
}

class _VideoPageWidgetState extends State<VideoPageWidget> {
  late VideoPlayerController _videoPlayerController;
  VideoPage get videoPage => widget.videoPage;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl((videoPage.videoUrl as LinkTypeURL).url)
      ..initialize().then((_) {
        _videoPlayerController.seekTo(Duration(seconds: 2));
        _videoPlayerController.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _videoPlayerController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                )
              : Container(),
          Text(videoPage.videoTitle),
          Text(videoPage.videoDescription),
          Text(videoPage.publishedAt.toIso8601String()),
        ],
      ),
    );
  }
}
