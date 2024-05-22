import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/block_button.dart';
import 'package:example/components/colors.dart';
import 'package:example/utils.dart';
import 'package:example/video_player.dart';
import 'package:flutter/material.dart';

class HeroSectionWidget extends StatelessWidget {
  const HeroSectionWidget(
    this.blok, {
    super.key,
  });

  final bloks.HeroSection blok;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (blok.backgroundVideo != null)
          VideoPlayerWidget(backgroundVideo: blok.backgroundVideo!)
        else if (blok.backgroundImage != null)
          Image.network(blok.backgroundImage?.fileName ?? ""),
        Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(blok.headline ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: blok.textColor == bloks.HeroSectionTextColorOption.light ? AppColors.white : null)),
                Text(
                  blok.subheadline ?? "",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: blok.textColor == bloks.HeroSectionTextColorOption.light ? AppColors.white : null),
                ),
                const SizedBox(height: 16),
                Wrap(
                    spacing: 16,
                    children: blok.buttons
                        .map((button) => BlockButton(
                              blokButton: button,
                              onPressed: () {
                                handleLinkPressed(context, button);
                              },
                            ))
                        .toList())
              ]),
        )
      ],
    );
  }
}
