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
  final Color backgroundColor = Colors.deepOrangeAccent;

  bool get _isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        fixedSize: const Size(double.infinity, 48),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: _isEnabled ? backgroundColor : backgroundColor.withOpacity(0.1),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: wrapContentWidth ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Text(
            text,
            maxLines: 1,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
