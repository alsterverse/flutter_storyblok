// flutter_storyblok_code_generator

// ignore_for_file: unused_import

library bloks; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:flutter_storyblok/fields.dart' as _i1;
import 'package:flutter_storyblok/flutter_storyblok.dart' as _i2;

enum ButtonStyleOption {
  default$('default'),
  ghost('ghost'),
  semiTransparent('semi'),
  unknown('unknown');

  const ButtonStyleOption(this.raw);

  factory ButtonStyleOption.fromName(String? name) {
    return switch (name) {
      'default' => ButtonStyleOption.default$,
      'ghost' => ButtonStyleOption.ghost,
      'semi' => ButtonStyleOption.semiTransparent,
      _ => ButtonStyleOption.unknown,
    };
  }

  final String raw;
}

enum ButtonTextColorOption {
  light('light'),
  dark('dark'),
  unknown('unknown');

  const ButtonTextColorOption(this.raw);

  factory ButtonTextColorOption.fromName(String? name) {
    return switch (name) {
      'light' => ButtonTextColorOption.light,
      'dark' => ButtonTextColorOption.dark,
      _ => ButtonTextColorOption.unknown,
    };
  }

  final String raw;
}

enum ButtonSizeOption {
  small('small'),
  medium('medium'),
  large('large'),
  unknown('unknown');

  const ButtonSizeOption(this.raw);

  factory ButtonSizeOption.fromName(String? name) {
    return switch (name) {
      'small' => ButtonSizeOption.small,
      'medium' => ButtonSizeOption.medium,
      'large' => ButtonSizeOption.large,
      _ => ButtonSizeOption.unknown,
    };
  }

  final String raw;
}

enum ButtonBorderRadiusOption {
  default$('default'),
  small('small'),
  unknown('unknown');

  const ButtonBorderRadiusOption(this.raw);

  factory ButtonBorderRadiusOption.fromName(String? name) {
    return switch (name) {
      'default' => ButtonBorderRadiusOption.default$,
      'small' => ButtonBorderRadiusOption.small,
      _ => ButtonBorderRadiusOption.unknown,
    };
  }

  final String raw;
}

enum FeaturedArticlesSectionColsOption {
  two('2'),
  three('3'),
  four('4'),
  unknown('unknown');

  const FeaturedArticlesSectionColsOption(this.raw);

  factory FeaturedArticlesSectionColsOption.fromName(String? name) {
    return switch (name) {
      '2' => FeaturedArticlesSectionColsOption.two,
      '3' => FeaturedArticlesSectionColsOption.three,
      '4' => FeaturedArticlesSectionColsOption.four,
      _ => FeaturedArticlesSectionColsOption.unknown,
    };
  }

  final String raw;
}

enum FormSectionFormOption {
  contact('contact'),
  newsletter('newsletter'),
  unknown('unknown');

  const FormSectionFormOption(this.raw);

  factory FormSectionFormOption.fromName(String? name) {
    return switch (name) {
      'contact' => FormSectionFormOption.contact,
      'newsletter' => FormSectionFormOption.newsletter,
      _ => FormSectionFormOption.unknown,
    };
  }

  final String raw;
}

enum FormSectionTextColorOption {
  light('light'),
  dark('dark'),
  unknown('unknown');

  const FormSectionTextColorOption(this.raw);

  factory FormSectionTextColorOption.fromName(String? name) {
    return switch (name) {
      'light' => FormSectionTextColorOption.light,
      'dark' => FormSectionTextColorOption.dark,
      _ => FormSectionTextColorOption.unknown,
    };
  }

  final String raw;
}

enum GridCardIconWidthOption {
  narrow80Px('80'),
  medium160Px('160'),
  wide240Px('240'),
  unknown('unknown');

  const GridCardIconWidthOption(this.raw);

  factory GridCardIconWidthOption.fromName(String? name) {
    return switch (name) {
      '80' => GridCardIconWidthOption.narrow80Px,
      '160' => GridCardIconWidthOption.medium160Px,
      '240' => GridCardIconWidthOption.wide240Px,
      _ => GridCardIconWidthOption.unknown,
    };
  }

  final String raw;
}

enum GridCardTextColorOption {
  light('light'),
  dark('dark'),
  unknown('unknown');

  const GridCardTextColorOption(this.raw);

  factory GridCardTextColorOption.fromName(String? name) {
    return switch (name) {
      'light' => GridCardTextColorOption.light,
      'dark' => GridCardTextColorOption.dark,
      _ => GridCardTextColorOption.unknown,
    };
  }

  final String raw;
}

sealed class GridSectionCardsRestrictedTypes {
  const GridSectionCardsRestrictedTypes();

  factory GridSectionCardsRestrictedTypes.fromJson(Map<String, dynamic> json) {
    final type = json['component'];
    return switch (type) {
      'grid-card' => GridSectionCardsRestrictedTypesGridCard.fromJson(json),
      'price-card' => GridSectionCardsRestrictedTypesPriceCard.fromJson(json),
      _ => throw 'Unrecognized type \'$type\' For class \'GridSectionCardsRestrictedTypes\''
    };
  }
}

final class GridSectionCardsRestrictedTypesGridCard extends GridSectionCardsRestrictedTypes {
  GridSectionCardsRestrictedTypesGridCard.fromJson(Map<String, dynamic> json) : gridCard = GridCard.fromJson(json);

  final GridCard gridCard;
}

final class GridSectionCardsRestrictedTypesPriceCard extends GridSectionCardsRestrictedTypes {
  GridSectionCardsRestrictedTypesPriceCard.fromJson(Map<String, dynamic> json) : priceCard = PriceCard.fromJson(json);

  final PriceCard priceCard;
}

enum GridSectionColsOption {
  two('2'),
  three('3'),
  four('4'),
  unknown('unknown');

  const GridSectionColsOption(this.raw);

  factory GridSectionColsOption.fromName(String? name) {
    return switch (name) {
      '2' => GridSectionColsOption.two,
      '3' => GridSectionColsOption.three,
      '4' => GridSectionColsOption.four,
      _ => GridSectionColsOption.unknown,
    };
  }

  final String raw;
}

enum HeroSectionTextColorOption {
  light('light'),
  dark('dark'),
  unknown('unknown');

  const HeroSectionTextColorOption(this.raw);

  factory HeroSectionTextColorOption.fromName(String? name) {
    return switch (name) {
      'light' => HeroSectionTextColorOption.light,
      'dark' => HeroSectionTextColorOption.dark,
      _ => HeroSectionTextColorOption.unknown,
    };
  }

  final String raw;
}

enum HeroSectionHorizontalAlignmentOption {
  left('left'),
  center('center'),
  unknown('unknown');

  const HeroSectionHorizontalAlignmentOption(this.raw);

  factory HeroSectionHorizontalAlignmentOption.fromName(String? name) {
    return switch (name) {
      'left' => HeroSectionHorizontalAlignmentOption.left,
      'center' => HeroSectionHorizontalAlignmentOption.center,
      _ => HeroSectionHorizontalAlignmentOption.unknown,
    };
  }

  final String raw;
}

enum HeroSectionVerticalAlignmentOption {
  top('start'),
  center('center'),
  bottom('end'),
  unknown('unknown');

  const HeroSectionVerticalAlignmentOption(this.raw);

  factory HeroSectionVerticalAlignmentOption.fromName(String? name) {
    return switch (name) {
      'start' => HeroSectionVerticalAlignmentOption.top,
      'center' => HeroSectionVerticalAlignmentOption.center,
      'end' => HeroSectionVerticalAlignmentOption.bottom,
      _ => HeroSectionVerticalAlignmentOption.unknown,
    };
  }

  final String raw;
}

enum ImageTextSectionImageLayoutOption {
  proportional('proportional'),
  fixedHeight('fixed-height'),
  unknown('unknown');

  const ImageTextSectionImageLayoutOption(this.raw);

  factory ImageTextSectionImageLayoutOption.fromName(String? name) {
    return switch (name) {
      'proportional' => ImageTextSectionImageLayoutOption.proportional,
      'fixed-height' => ImageTextSectionImageLayoutOption.fixedHeight,
      _ => ImageTextSectionImageLayoutOption.unknown,
    };
  }

  final String raw;
}

enum PersonalizedSectionPreviewOption {
  newVisitor('new_visitor'),
  returningVisitor('returning_visitor'),
  unknown('unknown');

  const PersonalizedSectionPreviewOption(this.raw);

  factory PersonalizedSectionPreviewOption.fromName(String? name) {
    return switch (name) {
      'new_visitor' => PersonalizedSectionPreviewOption.newVisitor,
      'returning_visitor' => PersonalizedSectionPreviewOption.returningVisitor,
      _ => PersonalizedSectionPreviewOption.unknown,
    };
  }

  final String raw;
}

enum SiteConfigFooterTextColorOption {
  light('light'),
  dark('dark'),
  unknown('unknown');

  const SiteConfigFooterTextColorOption(this.raw);

  factory SiteConfigFooterTextColorOption.fromName(String? name) {
    return switch (name) {
      'light' => SiteConfigFooterTextColorOption.light,
      'dark' => SiteConfigFooterTextColorOption.dark,
      _ => SiteConfigFooterTextColorOption.unknown,
    };
  }

  final String raw;
}

enum TextSectionAlignmentOption {
  left('left'),
  center('center'),
  unknown('unknown');

  const TextSectionAlignmentOption(this.raw);

  factory TextSectionAlignmentOption.fromName(String? name) {
    return switch (name) {
      'left' => TextSectionAlignmentOption.left,
      'center' => TextSectionAlignmentOption.center,
      _ => TextSectionAlignmentOption.unknown,
    };
  }

  final String raw;
}

enum BackgroundColors {
  white('white'),
  light('light'),
  unknown('unknown');

  const BackgroundColors(this.raw);

  factory BackgroundColors.fromName(String? name) {
    return switch (name) {
      'white' => BackgroundColors.white,
      'light' => BackgroundColors.light,
      _ => BackgroundColors.unknown,
    };
  }

  final String raw;
}

enum Colors {
  primary('primary'),
  secondary('secondary'),
  white('white'),
  light('light'),
  medium('medium'),
  dark('dark'),
  unknown('unknown');

  const Colors(this.raw);

  factory Colors.fromName(String? name) {
    return switch (name) {
      'primary' => Colors.primary,
      'secondary' => Colors.secondary,
      'white' => Colors.white,
      'light' => Colors.light,
      'medium' => Colors.medium,
      'dark' => Colors.dark,
      _ => Colors.unknown,
    };
  }

  final String raw;
}

enum Overlays {
  noOverlay('no-overlay'),
  $15Opacity('overlay-15'),
  $30Opacity('overlay-30'),
  pattern1('overlay-pattern-1'),
  unknown('unknown');

  const Overlays(this.raw);

  factory Overlays.fromName(String? name) {
    return switch (name) {
      'no-overlay' => Overlays.noOverlay,
      'overlay-15' => Overlays.$15Opacity,
      'overlay-30' => Overlays.$30Opacity,
      'overlay-pattern-1' => Overlays.pattern1,
      _ => Overlays.unknown,
    };
  }

  final String raw;
}

enum Fonts {
  roboto('Roboto, sans-serif'),
  robotoSlab('Roboto Slab, serif'),
  robotoSerif('Roboto Serif, sans-serif'),
  notoSerif('Noto Serif, serif'),
  oswald('Oswald, sans-serif'),
  montserrat('Montserrat, sans-serif'),
  spaceGrotesk('Space Grotesk, sans-serif'),
  unknown('unknown');

  const Fonts(this.raw);

  factory Fonts.fromName(String? name) {
    return switch (name) {
      'Roboto, sans-serif' => Fonts.roboto,
      'Roboto Slab, serif' => Fonts.robotoSlab,
      'Roboto Serif, sans-serif' => Fonts.robotoSerif,
      'Noto Serif, serif' => Fonts.notoSerif,
      'Oswald, sans-serif' => Fonts.oswald,
      'Montserrat, sans-serif' => Fonts.montserrat,
      'Space Grotesk, sans-serif' => Fonts.spaceGrotesk,
      _ => Fonts.unknown,
    };
  }

  final String raw;
}

/// This is the base class for all blocks defined in `Block Library`
sealed class Blok {
  const Blok();

  factory Blok.fromJson(Map<String, dynamic> json) {
    final type = json['component'];
    return switch (type) {
      'article-overview-page' => ArticleOverviewPage.fromJson(json),
      'article-page' => ArticlePage.fromJson(json),
      'author' => Author.fromJson(json),
      'badge' => Badge.fromJson(json),
      'banner' => Banner.fromJson(json),
      'banner-reference' => BannerReference.fromJson(json),
      'button' => Button.fromJson(json),
      'category' => Category.fromJson(json),
      'complex-hero-section' => ComplexHeroSection.fromJson(json),
      'default-page' => DefaultPage.fromJson(json),
      'featured-articles-section' => FeaturedArticlesSection.fromJson(json),
      'form-section' => FormSection.fromJson(json),
      'grid-card' => GridCard.fromJson(json),
      'grid-section' => GridSection.fromJson(json),
      'hero-section' => HeroSection.fromJson(json),
      'image-text-section' => ImageTextSection.fromJson(json),
      'label' => Label.fromJson(json),
      'nav-item' => NavItem.fromJson(json),
      'personalized-section' => PersonalizedSection.fromJson(json),
      'price-card' => PriceCard.fromJson(json),
      'richtext-youtube' => RichtextYoutube.fromJson(json),
      'rocket-customization-page' => RocketCustomizationPage.fromJson(json),
      'rocket-journey-page' => RocketJourneyPage.fromJson(json),
      'rocket-journey-scroll-section' => RocketJourneyScrollSection.fromJson(json),
      'single-product-section' => SingleProductSection.fromJson(json),
      'site-config' => SiteConfig.fromJson(json),
      'tabbed-content-entry' => TabbedContentEntry.fromJson(json),
      'tabbed-content-section' => TabbedContentSection.fromJson(json),
      'text-section' => TextSection.fromJson(json),
      'two-col-image-text-section' => TwoColImageTextSection.fromJson(json),
      _ => () {
          print('Unrecognized type \'$type\' For class \'Blok\'');
          return const UnrecognizedBlok();
        }()
    };
  }
}

final class UnrecognizedBlok extends Blok {
  const UnrecognizedBlok();
}

final class ArticleOverviewPage extends Blok {
  ArticleOverviewPage.fromJson(Map<String, dynamic> json) : headline = json['headline'];

  final String? headline;
}

final class ArticlePage extends Blok {
  ArticlePage.fromJson(Map<String, dynamic> json)
      : image = json['image'] == null ? null : _i1.ImageAsset.fromJson(json['image']),
        headline = json['headline'],
        subheadline = json['subheadline'],
        teaser = json['teaser'],
        text = json['text'] == null ? null : _i1.RichText.fromJson(json['text']),
        author = json['author'] == null ? null : _i2.StoryIdentifierUUID(json['author']),
        categories = List<String>.from(json['categories'] ?? const []).map(_i2.StoryIdentifierUUID.new).toList();

  final _i1.ImageAsset? image;

  final String? headline;

  final String? subheadline;

  final String? teaser;

  final _i1.RichText? text;

  final _i2.StoryIdentifierUUID? author;

  final List<_i2.StoryIdentifierUUID> categories;
}

final class Author extends Blok {
  Author.fromJson(Map<String, dynamic> json)
      : profilePicture = json['profile_picture'] == null ? null : _i1.ImageAsset.fromJson(json['profile_picture']),
        description = json['description'];

  final _i1.ImageAsset? profilePicture;

  final String? description;
}

final class Badge extends Blok {
  Badge.fromJson(Map<String, dynamic> json)
      : badge = json['badge'] == null ? null : _i1.ImageAsset.fromJson(json['badge']);

  final _i1.ImageAsset? badge;
}

final class Banner extends Blok {
  Banner.fromJson(Map<String, dynamic> json)
      : backgroundImage = json['background_image'] == null ? null : _i1.ImageAsset.fromJson(json['background_image']),
        backgroundVideo = json['background_video'] == null ? null : _i1.VideoAsset.fromJson(json['background_video']),
        enableBackgroundColor = json['enable_background_color'] ?? false,
        backgroundColor = json['background_color'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['background_color'],
                'native-color-picker',
              ),
        overlay = Overlays.fromName(json['overlay']),
        backgroundBrightness = json['background_brightness'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['background_brightness'],
                'storyblok-slider',
              ),
        backgroundBlur = json['background_blur'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['background_blur'],
                'storyblok-slider',
              ),
        textColor = Colors.fromName(json['text_color']),
        headline = json['headline'],
        subheadline = json['subheadline'],
        buttons = List<Map<String, dynamic>>.from(json['buttons'] ?? const []).map(Button.fromJson).toList(),
        fullWidth = json['full_width'] ?? false;

  final _i1.ImageAsset? backgroundImage;

  final _i1.VideoAsset? backgroundVideo;

  final bool enableBackgroundColor;

  final _i1.Plugin? backgroundColor;

  final Overlays overlay;

  final _i1.Plugin? backgroundBrightness;

  final _i1.Plugin? backgroundBlur;

  final Colors textColor;

  final String? headline;

  final String? subheadline;

  final List<Button> buttons;

  final bool fullWidth;
}

final class BannerReference extends Blok {
  BannerReference.fromJson(Map<String, dynamic> json)
      : banners = List<String>.from(json['banners'] ?? const []).map(_i2.StoryIdentifierUUID.new).toList();

  final List<_i2.StoryIdentifierUUID> banners;
}

final class Button extends Blok {
  Button.fromJson(Map<String, dynamic> json)
      : style = ButtonStyleOption.fromName(json['style']),
        backgroundColor = Colors.fromName(json['background_color']),
        textColor = ButtonTextColorOption.fromName(json['text_color']),
        size = ButtonSizeOption.fromName(json['size']),
        link = json['link'] is! Map<dynamic, dynamic> ? null : _i1.DefaultLink<Blok>.fromJson(json['link']),
        label = json['label'],
        borderRadius = ButtonBorderRadiusOption.fromName(json['border_radius']);

  final ButtonStyleOption style;

  final Colors backgroundColor;

  final ButtonTextColorOption textColor;

  final ButtonSizeOption size;

  final _i1.DefaultLink<Blok>? link;

  final String? label;

  final ButtonBorderRadiusOption borderRadius;
}

final class Category extends Blok {
  Category.fromJson(Map<String, dynamic> json)
      : headline = json['headline'],
        description = json['description'];

  final String? headline;

  final String? description;
}

final class ComplexHeroSection extends Blok {
  ComplexHeroSection.fromJson(Map<String, dynamic> json)
      : backgroundColor = BackgroundColors.fromName(json['background_color']),
        reverseLayout = json['reverse_layout'] ?? false,
        headline = json['headline'],
        lead = json['lead'],
        buttons = List<Map<String, dynamic>>.from(json['buttons'] ?? const []).map(Button.fromJson).toList(),
        labels = List<Map<String, dynamic>>.from(json['labels'] ?? const []).map(Label.fromJson).toList(),
        badges = List<Map<String, dynamic>>.from(json['badges'] ?? const []).map(Badge.fromJson).toList(),
        enableComposedImage = json['enable_composed_image'] ?? false,
        image1 = json['image_1'] == null ? null : _i1.ImageAsset.fromJson(json['image_1']),
        image2 = json['image_2'] == null ? null : _i1.ImageAsset.fromJson(json['image_2']),
        image3 = json['image_3'] == null ? null : _i1.ImageAsset.fromJson(json['image_3']),
        image4 = json['image_4'] == null ? null : _i1.ImageAsset.fromJson(json['image_4']),
        rotate = json['rotate'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['rotate'],
                'storyblok-slider',
              );

  final BackgroundColors backgroundColor;

  final bool reverseLayout;

  final String? headline;

  final String? lead;

  final List<Button> buttons;

  final List<Label> labels;

  final List<Badge> badges;

  final bool enableComposedImage;

  final _i1.ImageAsset? image1;

  final _i1.ImageAsset? image2;

  final _i1.ImageAsset? image3;

  final _i1.ImageAsset? image4;

  final _i1.Plugin? rotate;
}

final class DefaultPage extends Blok {
  DefaultPage.fromJson(Map<String, dynamic> json)
      : body = List<Map<String, dynamic>>.from(json['body'] ?? const []).map(Blok.fromJson).toList();

  final List<Blok> body;
}

final class FeaturedArticlesSection extends Blok {
  FeaturedArticlesSection.fromJson(Map<String, dynamic> json)
      : cols = FeaturedArticlesSectionColsOption.fromName(json['cols']),
        backgroundColor = BackgroundColors.fromName(json['background_color']),
        headline = json['headline'],
        lead = json['lead'],
        articles = List<String>.from(json['articles'] ?? const []).map(_i2.StoryIdentifierUUID.new).toList();

  final FeaturedArticlesSectionColsOption cols;

  final BackgroundColors backgroundColor;

  final String? headline;

  final String? lead;

  final List<_i2.StoryIdentifierUUID> articles;
}

final class FormSection extends Blok {
  FormSection.fromJson(Map<String, dynamic> json)
      : headline = json['headline'],
        lead = json['lead'],
        form = FormSectionFormOption.fromName(json['form']),
        textColor = FormSectionTextColorOption.fromName(json['text_color']),
        backgroundColor = Colors.fromName(json['background_color']),
        button = List<Map<String, dynamic>>.from(json['button'] ?? const []).map(Button.fromJson).toList().firstOrNull;

  final String? headline;

  final String? lead;

  final FormSectionFormOption form;

  final FormSectionTextColorOption textColor;

  final Colors backgroundColor;

  final Button? button;
}

final class GridCard extends Blok {
  GridCard.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        text = json['text'],
        button = List<Map<String, dynamic>>.from(json['button'] ?? const []).map(Button.fromJson).toList().firstOrNull,
        icon = json['icon'] == null ? null : _i1.ImageAsset.fromJson(json['icon']),
        iconWidth = GridCardIconWidthOption.fromName(json['icon_width']),
        backgroundColor = json['background_color'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['background_color'],
                'storyblok-palette',
              ),
        textColor = GridCardTextColorOption.fromName(json['text_color']);

  final String? label;

  final String? text;

  final Button? button;

  final _i1.ImageAsset? icon;

  final GridCardIconWidthOption iconWidth;

  final _i1.Plugin? backgroundColor;

  final GridCardTextColorOption textColor;
}

final class GridSection extends Blok {
  GridSection.fromJson(Map<String, dynamic> json)
      : cards = List<Map<String, dynamic>>.from(json['cards'] ?? const [])
            .map(GridSectionCardsRestrictedTypes.fromJson)
            .toList(),
        cols = GridSectionColsOption.fromName(json['cols']),
        headline = json['headline'],
        lead = json['lead'],
        backgroundColor = BackgroundColors.fromName(json['background_color']);

  final List<GridSectionCardsRestrictedTypes> cards;

  final GridSectionColsOption cols;

  final String? headline;

  final String? lead;

  final BackgroundColors backgroundColor;
}

final class HeroSection extends Blok {
  HeroSection.fromJson(Map<String, dynamic> json)
      : headline = json['headline'],
        overlay = Overlays.fromName(json['overlay']),
        textColor = HeroSectionTextColorOption.fromName(json['text_color']),
        subheadline = json['subheadline'],
        buttons = List<Map<String, dynamic>>.from(json['buttons'] ?? const []).map(Button.fromJson).toList(),
        horizontalAlignment = HeroSectionHorizontalAlignmentOption.fromName(json['horizontal_alignment']),
        verticalAlignment = HeroSectionVerticalAlignmentOption.fromName(json['vertical_alignment']),
        fullHeight = json['full_height'] ?? false,
        backgroundImage = json['background_image'] == null ? null : _i1.ImageAsset.fromJson(json['background_image']),
        backgroundVideo = json['background_video'] == null ? null : _i1.VideoAsset.fromJson(json['background_video']);

  final String? headline;

  final Overlays overlay;

  final HeroSectionTextColorOption textColor;

  final String? subheadline;

  final List<Button> buttons;

  final HeroSectionHorizontalAlignmentOption horizontalAlignment;

  final HeroSectionVerticalAlignmentOption verticalAlignment;

  final bool fullHeight;

  final _i1.ImageAsset? backgroundImage;

  final _i1.VideoAsset? backgroundVideo;
}

final class ImageTextSection extends Blok {
  ImageTextSection.fromJson(Map<String, dynamic> json)
      : headline = json['headline'],
        imageLayout = ImageTextSectionImageLayoutOption.fromName(json['image_layout']),
        text = json['text'] == null ? null : _i1.RichText.fromJson(json['text']),
        button = List<Map<String, dynamic>>.from(json['button'] ?? const []).map(Button.fromJson).toList().firstOrNull,
        image = json['image'] == null ? null : _i1.ImageAsset.fromJson(json['image']),
        reverseLayout = json['reverse_layout'] ?? false,
        backgroundColor = BackgroundColors.fromName(json['background_color']);

  final String? headline;

  final ImageTextSectionImageLayoutOption imageLayout;

  final _i1.RichText? text;

  final Button? button;

  final _i1.ImageAsset? image;

  final bool reverseLayout;

  final BackgroundColors backgroundColor;
}

final class Label extends Blok {
  Label.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        description = json['description'];

  final String? label;

  final String? description;
}

final class NavItem extends Blok {
  NavItem.fromJson(Map<String, dynamic> json)
      : link = json['link'] is! Map<dynamic, dynamic> ? null : _i1.DefaultLink<Blok>.fromJson(json['link']),
        label = json['label'];

  final _i1.DefaultLink<Blok>? link;

  final String? label;
}

final class PersonalizedSection extends Blok {
  PersonalizedSection.fromJson(Map<String, dynamic> json)
      : preview = PersonalizedSectionPreviewOption.fromName(json['preview']),
        returningVisitorBlocks =
            List<Map<String, dynamic>>.from(json['returning_visitor_blocks'] ?? const []).map(Blok.fromJson).toList(),
        newVisitorBlocks =
            List<Map<String, dynamic>>.from(json['new_visitor_blocks'] ?? const []).map(Blok.fromJson).toList();

  final PersonalizedSectionPreviewOption preview;

  final List<Blok> returningVisitorBlocks;

  final List<Blok> newVisitorBlocks;
}

final class PriceCard extends Blok {
  PriceCard.fromJson(Map<String, dynamic> json)
      : headline = json['headline'],
        subheadline = json['subheadline'],
        price = double.tryParse(json['price']),
        textBelowPrice = json['text_below_price'] == null ? null : _i1.RichText.fromJson(json['text_below_price']),
        button = List<Map<String, dynamic>>.from(json['button'] ?? const []).map(Button.fromJson).toList().firstOrNull,
        textBelowButton = json['text_below_button'] == null ? null : _i1.RichText.fromJson(json['text_below_button']),
        mostPopular = json['most_popular'] ?? false;

  final String? headline;

  final String? subheadline;

  final double? price;

  final _i1.RichText? textBelowPrice;

  final Button? button;

  final _i1.RichText? textBelowButton;

  final bool mostPopular;
}

final class RichtextYoutube extends Blok {
  RichtextYoutube.fromJson(Map<String, dynamic> json) : videoId = json['video_id'];

  final String? videoId;
}

final class RocketCustomizationPage extends Blok {
  RocketCustomizationPage.fromJson(Map<String, dynamic> json)
      : headline = json['headline'],
        description = json['description'],
        baseMaterial = json['baseMaterial'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['baseMaterial'],
                'sb-tres-material-plugin',
              ),
        accentMaterial = json['accentMaterial'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['accentMaterial'],
                'sb-tres-material-plugin',
              ),
        detailMaterial = json['detailMaterial'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['detailMaterial'],
                'sb-tres-material-plugin',
              );

  final String? headline;

  final String? description;

  final _i1.Plugin? baseMaterial;

  final _i1.Plugin? accentMaterial;

  final _i1.Plugin? detailMaterial;
}

final class RocketJourneyPage extends Blok {
  RocketJourneyPage.fromJson(Map<String, dynamic> json)
      : sections = List<Map<String, dynamic>>.from(json['sections'] ?? const [])
            .map(RocketJourneyScrollSection.fromJson)
            .toList();

  final List<RocketJourneyScrollSection> sections;
}

final class RocketJourneyScrollSection extends Blok {
  RocketJourneyScrollSection.fromJson(Map<String, dynamic> json)
      : headline = json['headline'],
        text = json['text'] == null ? null : _i1.RichText.fromJson(json['text']);

  final String? headline;

  final _i1.RichText? text;
}

final class SingleProductSection extends Blok {
  SingleProductSection.fromJson(Map<String, dynamic> json)
      : headline = json['headline'],
        overrideProductDescription = json['override_product_description'] ?? false,
        text = json['text'] == null ? null : _i1.RichText.fromJson(json['text']),
        button = List<Map<String, dynamic>>.from(json['button'] ?? const []).map(Button.fromJson).toList().firstOrNull,
        product = json['product'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['product'],
                'sb-shopify',
              ),
        reverseLayout = json['reverse_layout'] ?? false,
        backgroundColor = BackgroundColors.fromName(json['background_color']);

  final String? headline;

  final bool overrideProductDescription;

  final _i1.RichText? text;

  final Button? button;

  final _i1.Plugin? product;

  final bool reverseLayout;

  final BackgroundColors backgroundColor;
}

final class SiteConfig extends Blok {
  SiteConfig.fromJson(Map<String, dynamic> json)
      : headerDisableTransparency = json['header_disable_transparency'] ?? false,
        headerLight = json['header_light'] ?? false,
        disableRoundedCorners = json['disable_rounded_corners'] ?? false,
        footerTextColor = SiteConfigFooterTextColorOption.fromName(json['footer_text_color']),
        footerBackgroundColor = Colors.fromName(json['footer_background_color']),
        useCustomColors = json['use_custom_colors'] ?? false,
        primary = json['primary'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['primary'],
                'native-color-picker',
              ),
        secondary = json['secondary'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['secondary'],
                'native-color-picker',
              ),
        light = json['light'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['light'],
                'native-color-picker',
              ),
        medium = json['medium'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['medium'],
                'native-color-picker',
              ),
        dark = json['dark'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['dark'],
                'native-color-picker',
              ),
        coloredHeadlines = json['colored_headlines'] ?? false,
        useCustomFonts = json['use_custom_fonts'] ?? false,
        customFontDisplay = Fonts.fromName(json['custom_font_display']),
        customFontBody = Fonts.fromName(json['custom_font_body']),
        enableBreadcrumbs = json['enable_breadcrumbs'] ?? false,
        breadcrumbsExcludedStories = List<String>.from(json['breadcrumbs_excluded_stories'] ?? const [])
            .map(_i2.StoryIdentifierUUID.new)
            .toList(),
        footerLogo = json['footer_logo'] == null ? null : _i1.ImageAsset.fromJson(json['footer_logo']),
        footerAbout = json['footer_about'] == null ? null : _i1.RichText.fromJson(json['footer_about']),
        footerNav1Headline = json['footer_nav_1_headline'],
        footerNav1 = List<Map<String, dynamic>>.from(json['footer_nav_1'] ?? const []).map(NavItem.fromJson).toList(),
        footerNav2Headline = json['footer_nav_2_headline'],
        footerNav2 = List<Map<String, dynamic>>.from(json['footer_nav_2'] ?? const []).map(NavItem.fromJson).toList(),
        footerNav3Headline = json['footer_nav_3_headline'],
        footerNav3 = List<Map<String, dynamic>>.from(json['footer_nav_3'] ?? const []).map(NavItem.fromJson).toList(),
        headerLogo = json['header_logo'] == null ? null : _i1.ImageAsset.fromJson(json['header_logo']),
        headerAutoNav = json['header_auto_nav'] ?? false,
        headerAutoNavFolder = json['header_auto_nav_folder'] is! Map<dynamic, dynamic>
            ? null
            : _i1.Plugin.fromJson(
                json['header_auto_nav_folder'],
                'folder-selection-manuel-test',
              ),
        headerNav = List<Map<String, dynamic>>.from(json['header_nav'] ?? const []).map(NavItem.fromJson).toList(),
        headerButtons =
            List<Map<String, dynamic>>.from(json['header_buttons'] ?? const []).map(Button.fromJson).toList(),
        twitter = json['twitter'] is! Map<dynamic, dynamic> ? null : _i1.DefaultLink<Blok>.fromJson(json['twitter']),
        instagram =
            json['instagram'] is! Map<dynamic, dynamic> ? null : _i1.DefaultLink<Blok>.fromJson(json['instagram']),
        youtube = json['youtube'] is! Map<dynamic, dynamic> ? null : _i1.DefaultLink<Blok>.fromJson(json['youtube']),
        facebook = json['facebook'] is! Map<dynamic, dynamic> ? null : _i1.DefaultLink<Blok>.fromJson(json['facebook']);

  final bool headerDisableTransparency;

  final bool headerLight;

  final bool disableRoundedCorners;

  final SiteConfigFooterTextColorOption footerTextColor;

  final Colors footerBackgroundColor;

  final bool useCustomColors;

  final _i1.Plugin? primary;

  final _i1.Plugin? secondary;

  final _i1.Plugin? light;

  final _i1.Plugin? medium;

  final _i1.Plugin? dark;

  final bool coloredHeadlines;

  final bool useCustomFonts;

  final Fonts customFontDisplay;

  final Fonts customFontBody;

  final bool enableBreadcrumbs;

  final List<_i2.StoryIdentifierUUID> breadcrumbsExcludedStories;

  final _i1.ImageAsset? footerLogo;

  final _i1.RichText? footerAbout;

  final String? footerNav1Headline;

  final List<NavItem> footerNav1;

  final String? footerNav2Headline;

  final List<NavItem> footerNav2;

  final String? footerNav3Headline;

  final List<NavItem> footerNav3;

  final _i1.ImageAsset? headerLogo;

  final bool headerAutoNav;

  final _i1.Plugin? headerAutoNavFolder;

  final List<NavItem> headerNav;

  final List<Button> headerButtons;

  final _i1.DefaultLink<Blok>? twitter;

  final _i1.DefaultLink<Blok>? instagram;

  final _i1.DefaultLink<Blok>? youtube;

  final _i1.DefaultLink<Blok>? facebook;
}

final class TabbedContentEntry extends Blok {
  TabbedContentEntry.fromJson(Map<String, dynamic> json)
      : image = json['image'] == null ? null : _i1.ImageAsset.fromJson(json['image']),
        headline = json['headline'],
        description = json['description'],
        button = List<Map<String, dynamic>>.from(json['button'] ?? const []).map(Button.fromJson).toList().firstOrNull;

  final _i1.ImageAsset? image;

  final String? headline;

  final String? description;

  final Button? button;
}

final class TabbedContentSection extends Blok {
  TabbedContentSection.fromJson(Map<String, dynamic> json)
      : headline = json['headline'],
        alwaysAccordion = json['always_accordion'] ?? false,
        lead = json['lead'],
        entries =
            List<Map<String, dynamic>>.from(json['entries'] ?? const []).map(TabbedContentEntry.fromJson).toList();

  final String? headline;

  final bool alwaysAccordion;

  final String? lead;

  final List<TabbedContentEntry> entries;
}

final class TextSection extends Blok {
  TextSection.fromJson(Map<String, dynamic> json)
      : alignment = TextSectionAlignmentOption.fromName(json['alignment']),
        singleColorBackground = json['single_color_background'] ?? false,
        backgroundColor = BackgroundColors.fromName(json['background_color']),
        overlapPrecedingHero = json['overlap_preceding_hero'] ?? false,
        headline = json['headline'],
        lead = json['lead'],
        text = json['text'] == null ? null : _i1.RichText.fromJson(json['text']),
        button = List<Map<String, dynamic>>.from(json['button'] ?? const []).map(Button.fromJson).toList().firstOrNull;

  final TextSectionAlignmentOption alignment;

  final bool singleColorBackground;

  final BackgroundColors backgroundColor;

  final bool overlapPrecedingHero;

  final String? headline;

  final String? lead;

  final _i1.RichText? text;

  final Button? button;
}

final class TwoColImageTextSection extends Blok {
  TwoColImageTextSection.fromJson(Map<String, dynamic> json)
      : image1 = json['image_1'] == null ? null : _i1.ImageAsset.fromJson(json['image_1']),
        image2 = json['image_2'] == null ? null : _i1.ImageAsset.fromJson(json['image_2']),
        headline = json['headline'],
        backgroundColor = BackgroundColors.fromName(json['background_color']),
        subheadline = json['subheadline'];

  final _i1.ImageAsset? image1;

  final _i1.ImageAsset? image2;

  final String? headline;

  final BackgroundColors backgroundColor;

  final String? subheadline;
}
