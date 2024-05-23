import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/block_button.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/widgets.dart';

class ImageTextSectionWidget extends StatelessWidget {
  const ImageTextSectionWidget(this.blok, {super.key});

  final bloks.ImageTextSection blok;
  @override
  Widget build(BuildContext context) {
    final image = blok.image?.buildNetworkImage();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (image != null) image,
          const SizedBox(height: 16),
          SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (blok.headline != null && blok.headline!.isNotEmpty) ...[
                  Text(blok.headline!, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                ],
                StoryblokRichText(
                  content: blok.text?.content ?? [],
                  textAlign: TextAlign.center,
                  blockBuilder: (context, data) => bloks.Blok.fromJson(data).buildWidget(context),
                ),
                const SizedBox(height: 32),
                if (blok.button != null)
                  BlockButton(
                    blokButton: blok.button!,
                    onPressed: () async {
                      handleLinkPressed(context, blok.button);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
