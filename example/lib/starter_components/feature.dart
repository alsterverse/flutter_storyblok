import 'package:flutter/widgets.dart';

class Feature extends StatelessWidget {
  final String? name;

  const Feature({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final name = this.name;
    return Text(
      name ?? "",
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
