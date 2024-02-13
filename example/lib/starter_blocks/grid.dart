import 'package:example/bloks.generated.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Grid extends StatelessWidget {
  const Grid({super.key, required this.columns});
  final List<Blok>? columns;

  @override
  Widget build(BuildContext context) {
    if (columns == null || columns!.isEmpty) {
      return const SizedBox();
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
          child: Row(
              children: columns!
                  .map(
                    (e) => Container(
                      width: 300,
                      child: e.buildWidget(context),
                    ),
                  )
                  .separatedBy(() => Container(
                        width: 8.0,
                      ))
                  .toList()),
        ),
      );
    }
  }
}
