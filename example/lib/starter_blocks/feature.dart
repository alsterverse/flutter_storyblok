import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:flutter/material.dart';

class Feature extends StatelessWidget {
  final String? name;

  const Feature({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: AppColors.primary,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            width: 4,
            color: AppColors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: 600,
              height: 125,
              child: Center(
                child: TextATV.title(
                  name ?? "",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
