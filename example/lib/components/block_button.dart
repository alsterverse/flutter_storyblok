import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:flutter/material.dart';
import 'package:example/bloks.generated.dart' as bloks;

class BlockButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bloks.Button blokButton;

  BlockButton({
    super.key,
    required this.blokButton,
    this.onPressed,
  }) : text = blokButton.label ?? "";

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color backgroundColor;

    backgroundColor = switch (blokButton.backgroundColor) {
      bloks.Colors.primary => AppColors.primary,
      bloks.Colors.secondary => AppColors.secondary,
      bloks.Colors.white => AppColors.white,
      bloks.Colors.light => AppColors.light,
      bloks.Colors.medium => AppColors.medium,
      bloks.Colors.dark => AppColors.black,
      bloks.Colors.unknown => AppColors.primary,
    };

    var textColor = switch (blokButton.textColor) {
      bloks.TextColorButtonOption.light => AppColors.white,
      bloks.TextColorButtonOption.dark => AppColors.black,
      bloks.TextColorButtonOption.unknown => AppColors.white,
    };

    borderColor = Colors.transparent;

    switch (blokButton.style) {
      case bloks.StyleButtonOption.ghost:
        {
          textColor = backgroundColor;
          borderColor = backgroundColor;
          backgroundColor = Colors.transparent;
        }
      case bloks.StyleButtonOption.semiTransparent:
        {
          textColor = backgroundColor;
          borderColor = backgroundColor;
          backgroundColor = Colors.transparent;
        }
      case bloks.StyleButtonOption.default$:
      case bloks.StyleButtonOption.unknown:
        break;
    }

    final border = switch (blokButton.style) {
      bloks.StyleButtonOption.default$ => BorderSide.none,
      bloks.StyleButtonOption.ghost => BorderSide(color: borderColor),
      bloks.StyleButtonOption.semiTransparent => BorderSide(color: borderColor),
      bloks.StyleButtonOption.unknown => BorderSide.none,
    };

    final borderRadius = switch (blokButton.borderRadius) {
      bloks.BorderRadiusButtonOption.default$ => BorderRadius.circular(999),
      bloks.BorderRadiusButtonOption.small => BorderRadius.circular(4),
      bloks.BorderRadiusButtonOption.unknown => BorderRadius.circular(8),
      // TODO: Handle this case.
    };

    final padding = switch (blokButton.size) {
      bloks.SizeButtonOption.small => const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      bloks.SizeButtonOption.medium => const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      bloks.SizeButtonOption.large => const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      bloks.SizeButtonOption.unknown => const EdgeInsets.symmetric(vertical: 12, horizontal: 16)
    };

    final fontSize = switch (blokButton.size) {
      bloks.SizeButtonOption.small => 12.0,
      bloks.SizeButtonOption.medium => 14.0,
      bloks.SizeButtonOption.large => 18.0,
      bloks.SizeButtonOption.unknown => 14.0,
    };

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: border,
        ),
        padding: padding,
        backgroundColor: backgroundColor,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: textColor,
              fontSize: fontSize,
            ),
      ),
    );
  }
}
