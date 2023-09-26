import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/utils.dart';
import 'package:example/video_item_widget.dart';
import 'package:flutter/material.dart';

class CarouselBlockWidget extends StatelessWidget {
  final bloks.CarouselBlock carouselBlock;
  const CarouselBlockWidget({
    super.key,
    required this.carouselBlock,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(carouselBlock.heading),
        ),
        SizedBox(
          height: 150,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List<bloks.VideoItem>.from(carouselBlock.videos)
                  .map<Widget>((e) => VideoItemWidget.fromVideoItem(e, true))
                  .separatedBy(() => const SizedBox(width: 20))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
