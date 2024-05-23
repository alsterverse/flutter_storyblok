import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/snackbar.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/fields.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

Out? mapIfNotNull<In, Out>(In? dataIn, Out? Function(In) mapper) {
  if (dataIn != null) return mapper(dataIn);
  return null;
}

extension IterableUtils<E> on Iterable<E> {
  /// Inserts [separator] between every element of [this]
  Iterable<E> separatedBy(E Function() separator) => separatedByIndexed((_) => separator());

  /// Inserts [separator] between every element of [this]
  Iterable<E> separatedByIndexed(E Function(int index) separator) {
    if (length < 2) return this; // Require minimum of 2 elements
    return Iterable.generate(
      length * 2 - 1,
      (index) {
        final elementIndex = index ~/ 2;
        return index.isEven ? elementAt(elementIndex) : separator(elementIndex);
      },
    );
  }
}

extension DoubleExtensions on double {
  double roundToDecimals(int decimals) {
    assert(decimals >= 0);
    final n = pow(10, decimals);
    return (this * n).roundToDouble() / n;
  }
}

void handleLinkPressed(BuildContext context, bloks.Button? button) async {
  if (button == null) {
    showSnackbar(context, "Button is null");
    return;
  }

  final linkIdentifier = switch (button.link) {
    LinkStory<bloks.Blok> blok => blok.uuid,
    LinkURL<bloks.Blok> blok => blok.url,
    _ => null,
  };

  if (linkIdentifier is String && linkIdentifier.isNotEmpty) {
    final story = await storyblokClient.getStory(id: StoryIdentifierUUID(linkIdentifier));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => story.content.buildWidget(context)));
    return;
  }

  if (linkIdentifier is String && linkIdentifier.isEmpty) {
    showSnackbar(context, "Empty internal link", error: true);
    return;
  }

  if (linkIdentifier is Uri) {
    showSnackbar(context, "External URLs not implemented", error: true);
    return;
  }

  if (linkIdentifier == null) {
    showSnackbar(context, "Link is null", error: true);
    return;
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
