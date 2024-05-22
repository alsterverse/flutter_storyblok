import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:flutter/material.dart';

class AuthorWidget extends StatelessWidget {
  const AuthorWidget({this.name, required this.content, super.key});

  final String? name;
  final bloks.Author content;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  child: ClipOval(
                      child: Image.network(
                    content.profilePicture?.fileName ?? "",
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator(
                        strokeWidth: 10,
                        backgroundColor: AppColors.background,
                        color: AppColors.secondary,
                      );
                    },
                    fit: BoxFit.cover,
                    width: 64,
                    height: 64,
                  )),
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
