import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class VideoPageWidget extends StatefulWidget {
  final bloks.VideoPage videoPage;
  const VideoPageWidget({super.key, required this.videoPage});

  @override
  State<VideoPageWidget> createState() => _VideoPageWidgetState();
}

class _VideoPageWidgetState extends State<VideoPageWidget> {
  late VideoPlayerController _videoPlayerController;
  bloks.VideoPage get videoPage => widget.videoPage;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl((videoPage.videoUrl as LinkURL).url)
      ..initialize().then((_) {
        if (!mounted) return;
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
        elevation: 0,
        title: SizedBox(
          width: 150,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: Text(
              "ATV",
              style: headingStyle.copyWith(letterSpacing: -2),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.primaryFaded,
            height: 2,
          ),
        ),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: !_videoPlayerController.value.isInitialized
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () => _videoPlayerController.value.isPlaying
                        ? _videoPlayerController.pause()
                        : _videoPlayerController.play(),
                    child: VideoPlayer(_videoPlayerController)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(videoPage.publishedAt.toString().split(" ")[0],
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.white.withOpacity(0.6),
                                fontSize: 12,
                                height: 1.2)),
                        TextATV.title(
                          videoPage.videoTitle,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Share.share("Check out ${videoPage.videoTitle} at ATV!",
                            subject: "Share '${videoPage.videoTitle}'");
                      },
                      child: const Icon(
                        Icons.share,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextATV.body(
                  videoPage.videoDescription,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
