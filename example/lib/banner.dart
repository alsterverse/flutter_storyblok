import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/block_button.dart';
import 'package:example/components/colors.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget(this.blok, {super.key});

  final bloks.Banner blok;

  @override
  Widget build(BuildContext context) {
    final textColor = switch (blok.textColor) {
      bloks.Colors.primary => AppColors.primary,
      bloks.Colors.secondary => AppColors.secondary,
      bloks.Colors.white => AppColors.white,
      bloks.Colors.light => AppColors.light,
      bloks.Colors.medium => AppColors.medium,
      bloks.Colors.dark => AppColors.black,
      bloks.Colors.unknown => AppColors.primary,
    };

    final backgroundImage = blok.backgroundImage?.buildNetworkImage((imageProvider) => Image(
          image: imageProvider,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            color: switch (blok.textColor) {
              bloks.Colors.primary => AppColors.white,
              bloks.Colors.secondary => AppColors.white,
              bloks.Colors.white => AppColors.primary,
              bloks.Colors.light => AppColors.primary,
              bloks.Colors.medium => AppColors.white,
              bloks.Colors.dark => AppColors.white,
              bloks.Colors.unknown => AppColors.primary,
            },
          ),
        ));

    return SizedBox(
      height: 500,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (backgroundImage != null) Positioned.fill(child: backgroundImage),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(blok.headline ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: textColor)),
                const SizedBox(height: 16),
                if (blok.subheadline != null && blok.subheadline!.isNotEmpty) ...[
                  Text(blok.subheadline ?? "",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: textColor)),
                  const SizedBox(height: 32),
                ],
                Wrap(
                    spacing: 16,
                    children: blok.buttons
                        .map((button) => BlockButton(
                            blokButton: button,
                            onPressed: () {
                              handleLinkPressed(context, button);
                            }))
                        .toList())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
