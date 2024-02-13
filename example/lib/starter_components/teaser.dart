import 'package:flutter/widgets.dart';

class Teaser extends StatelessWidget {
  final String? headline;

  const Teaser({
    super.key,
    required this.headline,
  });

  @override
  Widget build(BuildContext context) {
    final headline = this.headline;
    return Text(
      headline ?? "",
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
