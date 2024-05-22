import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/block_button.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class TabbedContentEntryWidget extends StatelessWidget {
  const TabbedContentEntryWidget(this.blok, {super.key});

  final bloks.TabbedContentEntry blok;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Image.network(blok.image?.fileName ?? "", loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
      }),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(blok.description ?? ""),
      ),
      const SizedBox(height: 32),
      if (blok.button != null)
        BlockButton(
            blokButton: blok.button!,
            onPressed: () {
              handleLinkPressed(context, blok.button);
            }),
      const SizedBox(height: 16),
    ]);
  }
}
