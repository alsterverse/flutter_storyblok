import 'package:example/block_widget_builder.dart';
import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/colors.dart';
import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.page,
  });

  final bloks.DefaultPage page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Demo Space",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.white, letterSpacing: -2),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            color: AppColors.accent,
            height: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var item in page.body) ...[
              item.buildWidget(context),
              const SizedBox(height: 32),
            ]
          ],
        ),
      ),
    );
  }
}
