import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';

class GridSectionWidget extends StatelessWidget {
  const GridSectionWidget(this.blok, {super.key});

  final bloks.GridSection blok;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: switch (blok.backgroundColor) {
        bloks.BackgroundColors.light => AppColors.background,
        bloks.BackgroundColors.white => AppColors.white,
        bloks.BackgroundColors.unknown => AppColors.background
      },
      padding: blok.backgroundColor == bloks.BackgroundColors.white ? const EdgeInsets.symmetric(vertical: 32) : null,
      child: Column(
        children: [
          Text(
            blok.headline ?? "",
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          if (blok.lead != null || blok.lead!.isNotEmpty)
            Text(
              blok.lead!,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: blok.cards.map((card) {
                return switch (card) {
                  bloks.PriceCard blok => blok.buildWidget(context),
                  bloks.GridCard blok => blok.buildWidget(context),
                  _ => const SizedBox.shrink(),
                };
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
