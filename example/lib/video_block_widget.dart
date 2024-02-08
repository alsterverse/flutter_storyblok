import 'package:example/bloks.generated.dart' as bloks;

import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class VideoBlockWidget extends StatefulWidget {
  final bloks.VideoBlock videoBlock;

  const VideoBlockWidget({
    super.key,
    required this.videoBlock,
  });

  @override
  State<VideoBlockWidget> createState() => _VideoBlockWidgetState();
}

class _VideoBlockWidgetState extends State<VideoBlockWidget> {
  late VideoPlayerController _videoPlayerController;
  bloks.VideoBlock get videoBlock => widget.videoBlock;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoBlock.videos.fileName))
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
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: !_videoPlayerController.value.isInitialized
            ? const SizedBox.shrink()
            : GestureDetector(
            onTap: () => _videoPlayerController.value.isPlaying
                ? _videoPlayerController.pause()
                : _videoPlayerController.play(),
            child: VideoPlayer(_videoPlayerController)),
      ),
      //Video.network(videoBlock.videos.name),
    );
  }
}
