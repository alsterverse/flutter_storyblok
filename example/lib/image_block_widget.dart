import 'package:example/bloks.generated.dart' as bloks;
import 'package:flutter/widgets.dart';

class ImageBlockWidget extends StatelessWidget {
  final bloks.ImageBlock imageBlock;

  const ImageBlockWidget({
    super.key,
    required this.imageBlock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Image.network(imageBlock.image.fileName),
    );
  }
}
