import 'package:example/author.dart';
import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/main.dart';
import 'package:example/rich_text_content.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class ArticlePageScreen extends StatelessWidget {
  const ArticlePageScreen(this.blok, {super.key});
  final bloks.ArticlePage blok;

  @override
  Widget build(BuildContext context) {
    final author = blok.author != null ? storyblokClient.getStory(id: blok.author!) : null;
    final image = blok.image?.buildNetworkImage();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          blok.headline ?? "",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (image != null) image,
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(blok.subheadline ?? "", style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  StoryblokRichTextContent(content: blok.text?.content ?? []),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (author != null)
              FutureBuilder(
                future: author,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (data == null) return const CircularProgressIndicator();
                  if (snapshot.hasError) return Text(snapshot.error.toString());
                  return AuthorWidget(name: data.name, content: data.content as bloks.Author);
                },
              ),
          ],
        ),
      ),
    );
  }
}
