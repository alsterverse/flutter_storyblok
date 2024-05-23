import 'package:example/bloks.generated.dart' as bloks;
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen(this.blok, {super.key});

  final bloks.Category blok;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(blok.headline == null ? "Categories" : blok.headline!),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blok.description ?? "",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              const Divider(),
              Expanded(
                child: Center(
                  child: Text(
                    "Not yet implemented! 🚀",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
