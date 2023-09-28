import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/text.dart';
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
          child: TextATV.subtitle(carouselBlock.heading),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: carouselBlock.isNotable ? 300 : 150,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: carouselBlock.videos
                  .map<Widget>((e) => VideoItemWidget.fromVideoItem(e, true, carouselBlock.isNotable))
                  .separatedBy(() => const SizedBox(width: 20))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
