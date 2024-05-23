import 'package:example/colors.dart';
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
      bloks.ButtonTextColorOption.light => AppColors.white,
      bloks.ButtonTextColorOption.dark => AppColors.black,
      bloks.ButtonTextColorOption.unknown => AppColors.white,
    };

    borderColor = Colors.transparent;

    switch (blokButton.style) {
      case bloks.ButtonStyleOption.ghost:
        {
          textColor = backgroundColor;
          borderColor = backgroundColor;
          backgroundColor = Colors.transparent;
        }
      case bloks.ButtonStyleOption.semiTransparent:
        {
          textColor = backgroundColor;
          borderColor = backgroundColor;
          backgroundColor = Colors.transparent;
        }
      case bloks.ButtonStyleOption.default$:
      case bloks.ButtonStyleOption.unknown:
        break;
    }

    final border = switch (blokButton.style) {
      bloks.ButtonStyleOption.default$ => BorderSide.none,
      bloks.ButtonStyleOption.ghost => BorderSide(color: borderColor),
      bloks.ButtonStyleOption.semiTransparent => BorderSide(color: borderColor),
      bloks.ButtonStyleOption.unknown => BorderSide.none,
    };

    final borderRadius = switch (blokButton.borderRadius) {
      bloks.ButtonBorderRadiusOption.default$ => BorderRadius.circular(999),
      bloks.ButtonBorderRadiusOption.small => BorderRadius.circular(4),
      bloks.ButtonBorderRadiusOption.unknown => BorderRadius.circular(8),
    };

    final fontSize = switch (blokButton.size) {
      bloks.ButtonSizeOption.small => 12.0,
      bloks.ButtonSizeOption.medium => 14.0,
      bloks.ButtonSizeOption.large => 18.0,
      bloks.ButtonSizeOption.unknown => 14.0,
    };

    final padding = switch (blokButton.size) {
      bloks.ButtonSizeOption.small => EdgeInsets.symmetric(vertical: fontSize, horizontal: fontSize * 2),
      bloks.ButtonSizeOption.medium => EdgeInsets.symmetric(vertical: fontSize, horizontal: fontSize * 2),
      bloks.ButtonSizeOption.large => EdgeInsets.symmetric(vertical: fontSize, horizontal: fontSize * 2),
      bloks.ButtonSizeOption.unknown => EdgeInsets.symmetric(vertical: fontSize, horizontal: fontSize * 2)
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
