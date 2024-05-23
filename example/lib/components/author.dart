import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/colors.dart';
import 'package:example/utils/blocks_extensions.dart';
import 'package:flutter/material.dart';

class AuthorWidget extends StatelessWidget {
  const AuthorWidget({this.name, required this.content, super.key});

  final String? name;
  final bloks.Author content;
  @override
  Widget build(BuildContext context) {
    final profilePicture = content.profilePicture?.buildNetworkImage();
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                if (profilePicture != null)
                  SizedBox.square(
                    dimension: 64,
                    child: ClipOval(child: profilePicture),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Author", style: Theme.of(context).textTheme.headlineSmall),
                      Text(name ?? "", style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(content.description ?? ""),
          ],
        ),
      ),
    );
  }
}
