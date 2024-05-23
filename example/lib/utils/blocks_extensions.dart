import 'dart:async';
import 'dart:ui' as ui;
import 'package:example/block_widget_builder.dart';
import 'package:example/main.dart';
import 'package:example/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/fields.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

extension LinkOpen<T> on Link<T> {
  void open(BuildContext context) async {
    final link = this;
    switch (link) {
      case LinkStory():
        if (link.uuid.isNotEmpty) {
          final story = await storyblokClient.getStory(id: StoryIdentifierUUID(link.uuid));
          if (context.mounted) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => story.content.buildWidget(context)));
          }
        } else {
          showSnackbar(context, "Empty link", error: true);
        }
      case LinkURL():
        showSnackbar(context, "External URLs not implemented", error: true);
      case LinkAsset():
        showSnackbar(context, "Assets not implemented", error: true);
      case LinkEmail():
        showSnackbar(context, "Email not implemented", error: true);
    }
  }
}

extension ImageAssetToWidget on ImageAsset {
  Widget buildNetworkImage([Image Function(ImageProvider imageProvider)? imageBuilder]) {
    final completer = Completer<ui.Image>();
    final imageProvider = NetworkImage(fileName)
      ..resolve(ImageConfiguration.empty).addListener(ImageStreamListener(
        (image, _) => completer.complete(Future.value(image.image)),
      ));
    return FutureBuilder(
      future: completer.future,
      builder: (context, snapshot) {
        final error = snapshot.error;
        if (error != null) return Text(error.toString());
        final data = snapshot.data;
        if (data == null) return const Center(child: CircularProgressIndicator());
        final image =
            imageBuilder == null ? Image(image: imageProvider, fit: BoxFit.cover) : imageBuilder(imageProvider);
        return AspectRatio(aspectRatio: data.width / data.height, child: image);
      },
    );
  }
}
