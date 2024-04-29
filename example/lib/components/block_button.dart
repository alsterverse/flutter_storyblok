import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:flutter/material.dart';

class BlockButton extends StatelessWidget {
  const BlockButton(
    this.text, {
    super.key,
    this.wrapContentWidth = false,
    required this.onPressed,
  });

  final String text;
  final bool wrapContentWidth;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        height: 150,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.white.withOpacity(0.1)),
            color: const Color.fromARGB(255, 37, 35, 40)),
        child: TextATV.button(
          text,
        ),
      ),
    );
  }
}
/*

TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: _isEnabled ? AppColors.primary : AppColors.primary.withOpacity(0.1),
        shape: const StadiumBorder(),
      ),
      ),
    );
 */
