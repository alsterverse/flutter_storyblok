import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/block_button.dart';
import 'package:example/components/colors.dart';
import 'package:example/rich_text_content.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GridCardWidget extends StatelessWidget {
  const GridCardWidget(this.blok, {super.key});

  final bloks.GridCard blok;

  @override
  Widget build(BuildContext context) {
    final hexColor = blok.backgroundColor?.data["value"] ?? "";

    final size = switch (blok.iconWidth) {
      bloks.GridCardIconWidthOption.narrow80px => 80.0,
      bloks.GridCardIconWidthOption.medium160px => 160.0,
      bloks.GridCardIconWidthOption.wide240px => 240.0,
      bloks.GridCardIconWidthOption.unknown => 80.0,
    };

    final textColor = switch (blok.textColor) {
      bloks.GridCardTextColorOption.light => AppColors.light,
      bloks.GridCardTextColorOption.dark => AppColors.black,
      bloks.GridCardTextColorOption.unknown => AppColors.black,
    };

    return Container(
      decoration: BoxDecoration(
        color: hexColor.isEmpty ? AppColors.white : HexColor(hexColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.network(
            blok.icon?.fileName ?? "",
            width: size,
          ),
          Text(
            blok.label ?? "",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: textColor),
          ),
          const SizedBox(height: 16),
          Flexible(
              child: Text(blok.text ?? "", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor))),
          const SizedBox(height: 16),
          if (blok.button != null)
            BlockButton(
                blokButton: blok.button!,
                onPressed: () async {
                  handleLinkPressed(context, blok.button);
                }),
        ],
      ),
    );
  }
}
