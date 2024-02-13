import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:flutter/material.dart';

class Teaser extends StatelessWidget {
  final String? headline;

  const Teaser({
    super.key,
    required this.headline,
  });

  @override
  Widget build(BuildContext context) {
    final headline = this.headline;
    return Center(
      child: Card(
        elevation: 0,
        color: AppColors.black,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            width: 4,
            color: AppColors.purple,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 300,
            height: 125,
            child: Center(
              child: ListTile(
                title: TextATV.title(
                  headline ?? "",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
