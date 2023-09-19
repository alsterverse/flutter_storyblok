import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/field_types.dart';
import 'package:flutter_storyblok/metadata.dart';
import 'package:flutter_storyblok/reflector.dart';
import 'package:flutter_storyblok/request_parameters.dart';
import 'package:flutter_storyblok/serializer.dart';
import 'package:flutter_storyblok/utils.dart';

@reflector
@Name("ArticleListPage")
final class ArticleListPage extends StoryblokWidget {
  final FieldTypeText header;
  final FieldTypeBlocks<ArticleItem> articleItems;
  const ArticleListPage(this.header, this.articleItems);

  factory ArticleListPage.fromJson(JSONMap json) => ArticleListPage(
        json["header"],
        FieldTypeBlocks.from(json["articleItems"]),
      );

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(header.text),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: articleItems.blocks
            .map<Widget>((e) => GestureDetector(
                  onTap: () => _openStory(context, e.articleLink.uuid),
                  child: e.buildWidget(context),
                ))
            .separatedBy(() => const SizedBox(height: 20))
            .toList(),
      ),
    );
  }

  Future _openStory(BuildContext context, String uuid) async {
    final navigator = Navigator.of(context);
    final story = await storyblokClient.getStory(StoryIdentifierUUID(uuid));
    final w = storyblokSerializer.serializeJson(story.content);
    navigator.push(MaterialPageRoute(builder: ((context) => w.buildWidget(context))));
  }
}

@reflector
final class ArticlePage extends StoryblokWidget {
  final FieldTypeText header;
  final FieldTypeBlocks body;
  const ArticlePage(this.header, this.body);

  factory ArticlePage.fromJson(JSONMap json) => ArticlePage(
        json["header"],
        FieldTypeBlocks.from(json["body"]),
      );

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(header.text),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: body.blocks
            .map<Widget>((e) => e.buildWidget(context))
            .separatedBy(() => const SizedBox(height: 20))
            .toList(),
      ),
    );
  }
}

@reflector
@Name("Column")
final class StoryblokColumn extends StoryblokWidget {
  final FieldTypeValue<MainAlignment>? mainAxisAlignment;
  final FieldTypeBlocks children;
  const StoryblokColumn(this.mainAxisAlignment, this.children);

  factory StoryblokColumn.fromJson(JSONMap json) => StoryblokColumn(
        FieldTypeValue.from(json["mainAxisAlignment"]),
        json["children"],
      );

  @override
  Widget buildWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment?.value.mainAxisAlignment ?? MainAxisAlignment.values.first,
      children: children.blocks.map((e) => e.buildWidget(context)).toList(),
    );
  }
}

@reflector
@Name("Row")
final class StoryblokRow implements StoryblokWidget {
  final FieldTypeValue<MainAlignment>? mainAxisAlignment;
  final FieldTypeBlocks children;
  const StoryblokRow(this.mainAxisAlignment, this.children);

  factory StoryblokRow.fromJson(JSONMap json) => StoryblokRow(
        FieldTypeValue.from(json["mainAxisAlignment"]),
        json["children"],
      );

  @override
  Widget buildWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment?.value.mainAxisAlignment ?? MainAxisAlignment.values.first,
      children: children.blocks.map((e) => e.buildWidget(context)).toList(),
    );
  }
}

@reflector
@Name("Text")
final class StoryblokText implements StoryblokWidget {
  final FieldTypeText text;
  const StoryblokText(this.text);

  factory StoryblokText.fromJson(JSONMap json) => StoryblokText(
        json["text"],
      );

  @override
  Widget buildWidget(BuildContext context) {
    return Text(text.text);
  }
}

@reflector
@Name("Image")
final class StoryblokImage implements StoryblokWidget {
  @Name("image")
  final FieldTypeAsset asset;
  const StoryblokImage(this.asset);

  factory StoryblokImage.fromJson(JSONMap json) => StoryblokImage(
        json["image"],
      );

  @override
  Widget buildWidget(BuildContext context) {
    return Image.network(asset.fileName);
  }
}

@reflector
final class ArticleItem implements StoryblokWidget {
  final FieldTypeText title;
  final FieldTypeText subtitle;
  final FieldTypeLink articleLink;
  const ArticleItem(this.title, this.subtitle, this.articleLink);

  factory ArticleItem.fromJson(JSONMap json) => ArticleItem(
        json["title"],
        json["subtitle"],
        json["articleLink"],
      );

  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.text),
          Text(subtitle.text),
        ],
      ),
    );
  }
}

@reflector
final class MainAlignment {
  final MainAxisAlignment mainAxisAlignment;
  MainAlignment(String name) : mainAxisAlignment = MainAxisAlignment.values.byName(name);
}

@reflector
@Name("Flex")
final class StoryblokFlex implements StoryblokWidget {
  final FieldTypeNumber flex;
  final FieldTypeBlocks child;
  const StoryblokFlex(this.flex, this.child);

  factory StoryblokFlex.fromJson(JSONMap json) => StoryblokFlex(
        json["flex"],
        FieldTypeBlocks.from(json["child"]),
      );

  @override
  Widget buildWidget(BuildContext context) {
    return Flexible(flex: flex.value.toInt(), child: child.blocks.first.buildWidget(context));
  }
}
