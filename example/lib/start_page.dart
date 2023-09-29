import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/components/text.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({
    super.key,
    required this.startPage,
  });

  final bloks.StartPage startPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: CircleAvatar(
          minRadius: 20,
          backgroundColor: AppColors.primary,
          child: Text(
            "ATV",
            style: headingStyle,
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
        children: startPage.content
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
