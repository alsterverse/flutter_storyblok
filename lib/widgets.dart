library;

import 'package:flutter/material.dart';
import 'package:flutter_storyblok/src/fields/rich_text.dart';
import 'package:flutter_storyblok/src/widgets/storyblok_color.dart';

export 'src/widgets/storyblok_color.dart';
export 'src/widgets/rich_text.dart';

extension RichTextLeafMarkTextStyleColor on RichTextLeafMarkTextStyle {
  Color get color => StoryblokColor.fromString(colorString);
}

extension RichTextLeafMarkHighlightColor on RichTextLeafMarkHighlight {
  Color get color => StoryblokColor.fromString(colorString);
}
