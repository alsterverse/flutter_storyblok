import 'package:example/bloks.generated.dart';
import 'package:example/components/text.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

//Rename to Page later, to fit the starter block
class Page extends StatelessWidget {
  final List<Blok> body;

  const Page({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final body = this.body;
    return Scaffold(
      appBar: AppBar(title: TextATV.carouselHeading("Blocks".toUpperCase())),
      body: Center(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: body.map((e) => e.buildWidget(context)).separatedBy(() => const SizedBox(height: 24)).toList()),
      ),
    );
  }
}
