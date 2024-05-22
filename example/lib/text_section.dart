import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/block_button.dart';
import 'package:example/components/colors.dart';
import 'package:example/rich_text_content.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class TextSectionWidget extends StatelessWidget {
  const TextSectionWidget(this.blok, {super.key});

  final bloks.TextSection blok;

  @override
  Widget build(BuildContext context) {
    final button = blok.button;
    final alignment = blok.alignment == bloks.TextSectionAlignmentOption.center ? TextAlign.center : TextAlign.start;

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: switch (blok.backgroundColor) {
        bloks.BackgroundColors.light => AppColors.background,
        bloks.BackgroundColors.white => AppColors.white,
        bloks.BackgroundColors.unknown => AppColors.white,
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: switch (blok.backgroundColor) {
            bloks.BackgroundColors.light => AppColors.white,
            bloks.BackgroundColors.white => AppColors.background,
            bloks.BackgroundColors.unknown => AppColors.background,
          },
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(blok.headline ?? "", textAlign: alignment, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            Text(blok.lead ?? "", textAlign: alignment, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            StoryblokRichTextContent(content: blok.text?.content ?? []),
            const SizedBox(height: 32),
            if (button != null)
              BlockButton(
                blokButton: blok.button!,
                onPressed: () {
                  handleLinkPressed(context, blok.button);
                },
              )
          ],
        ),
      ),
    );
  }
}
