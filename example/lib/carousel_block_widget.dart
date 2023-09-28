import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:example/utils.dart';
import 'package:example/video_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            carouselBlock.heading.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.white, fontSize: 12, height: 1.2),
          ),
        ),
        SizedBox(
          height: carouselBlock.isNotable ? 320 : 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<bloks.VideoItem>.from(carouselBlock.videos)
                  .map<Widget>((e) => VideoItemWidget.fromVideoItem(e, true, carouselBlock.isNotable))
                  .separatedBy(() => const SizedBox(width: 12))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
