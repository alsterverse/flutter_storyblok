import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/block_button.dart';
import 'package:example/utils/blocks_extensions.dart';
import 'package:example/utils/utils.dart';
import 'package:flutter/material.dart';

class TabbedContentEntryWidget extends StatelessWidget {
  const TabbedContentEntryWidget(this.blok, {super.key});

  final bloks.TabbedContentEntry blok;

  @override
  Widget build(BuildContext context) {
    final image = blok.image?.buildNetworkImage();
    return Column(
      children: [
        if (image != null) image,
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(blok.description ?? ""),
        ),
        const SizedBox(height: 32),
        if (blok.button != null)
          BlockButton(
            blokButton: blok.button!,
            onPressed: () => mapIfNotNull(blok.button!.link, (link) => link.open(context)),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
