import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.text, {
    super.key,
    this.wrapContentWidth = false,
    required this.onPressed,
  });

  final String text;
  final bool wrapContentWidth;
  final VoidCallback? onPressed;

  bool get _isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: _isEnabled ? AppColors.primary : AppColors.primary.withOpacity(0.1),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: wrapContentWidth ? MainAxisSize.min : MainAxisSize.max,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextATV.button(
            text,
          ),
        ],
      ),
    );
  }
}
