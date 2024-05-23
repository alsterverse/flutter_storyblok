import 'package:flutter/material.dart';
import 'package:flutter_storyblok/fields.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key, required this.backgroundVideo});

  final VideoAsset backgroundVideo;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoUrl = Uri.parse(widget.backgroundVideo.fileName);
    _controller = VideoPlayerController.networkUrl(videoUrl)
      ..setLooping(true)
      ..initialize().then((_) => setState(() {
            _controller.play();
          }));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
