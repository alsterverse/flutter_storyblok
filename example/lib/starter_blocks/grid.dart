import 'package:flutter/widgets.dart';

class Grid extends StatelessWidget {
  const Grid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "I'm a grid",
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
