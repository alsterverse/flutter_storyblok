import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.page,
  });

  final bloks.Page page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: SizedBox(
          width: 150,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: Text(
              "ATV",
              style: headingStyle.copyWith(letterSpacing: -2),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.primaryFaded,
            height: 2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: page.body
            .map((e) {
              final widget = e.buildWidget(context);
              if (e is bloks.CarouselBlock) return widget;
              return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: widget);
            })
            .separatedBy(() => const SizedBox(height: 32))
            .toList(),
      ),
    );
  }
}
