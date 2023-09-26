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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const CircleAvatar(
          backgroundColor: Colors.deepPurpleAccent,
          child: Text(
            "ATV",
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _videoPlayerController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      videoPage.videoTitle,
                      style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      videoPage.publishedAt.toString().split(" ")[0],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  videoPage.videoDescription,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
