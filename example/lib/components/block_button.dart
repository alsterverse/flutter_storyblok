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
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: const Color.fromARGB(255, 37, 35, 40),
        padding: const EdgeInsets.all(24),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        fixedSize: const Size.fromHeight(150),
      ),
      child: TextATV.button(
        text,
      ),
    );
  }
}
