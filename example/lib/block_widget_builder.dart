import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/article_overview_page.dart';
import 'package:example/components/article_page_screen.dart';
import 'package:example/components/banner.dart';
import 'package:example/components/banner_reference.dart';
import 'package:example/components/category.dart';
import 'package:example/components/featured_articles_section.dart';
import 'package:example/components/form_section.dart';
import 'package:example/components/grid_card.dart';
import 'package:example/components/grid_section.dart';
import 'package:example/components/hero_section.dart';
import 'package:example/components/image_text_section.dart';
import 'package:example/components/page.dart' as starter_blocks;
import 'package:example/components/tabbed_content_entry.dart';
import 'package:example/components/tabbed_content_section.dart';
import 'package:example/components/text_section.dart';
import 'package:flutter/material.dart';

extension BlockWidget on bloks.Blok {
  Widget buildWidget(BuildContext context) {
    return switch (this) {
      bloks.ArticleOverviewPage blok => ArticleOverviewPageScreen(blok),
      bloks.ArticlePage blok => ArticlePageScreen(blok),
      bloks.Author blok => Text(blok.runtimeType.toString()),
      bloks.Badge blok => Text(blok.runtimeType.toString()),
      bloks.Banner blok => BannerWidget(blok),
      bloks.BannerReference blok => BannerReferenceWidget(blok),
      bloks.Button blok => Text(blok.runtimeType.toString()),
      bloks.Category blok => CategoryScreen(blok),
      bloks.ComplexHeroSection blok => Text(blok.runtimeType.toString()),
      bloks.DefaultPage blok => starter_blocks.Page(page: blok),
      bloks.FeaturedArticlesSection blok => FeaturedArticlesSectionWidget(blok),
      bloks.FormSection blok => FormSectionWidget(blok),
      bloks.GridCard blok => GridCardWidget(blok),
      bloks.GridSection blok => GridSectionWidget(blok),
      bloks.HeroSection blok => HeroSectionWidget(blok),
      bloks.ImageTextSection blok => ImageTextSectionWidget(blok),
      bloks.Label blok => Text(blok.runtimeType.toString()),
      bloks.NavItem blok => Text(blok.runtimeType.toString()),
      bloks.PersonalizedSection blok => Text(blok.runtimeType.toString()),
      bloks.PriceCard blok => Text(blok.runtimeType.toString()),
      bloks.RichtextYoutube blok => Text(blok.runtimeType.toString()),
      bloks.RocketCustomizationPage blok => Text(blok.runtimeType.toString()),
      bloks.RocketJourneyPage blok => Text(blok.runtimeType.toString()),
      bloks.RocketJourneyScrollSection blok => Text(blok.runtimeType.toString()),
      bloks.SingleProductSection blok => Text(blok.runtimeType.toString()),
      bloks.SiteConfig blok => Text(blok.runtimeType.toString()),
      bloks.TabbedContentEntry blok => TabbedContentEntryWidget(blok),
      bloks.TabbedContentSection blok => TabbedContentSectionWidget(blok),
      bloks.TextSection blok => TextSectionWidget(blok),
      bloks.TwoColImageTextSection blok => Text(blok.runtimeType.toString()),
      bloks.UnrecognizedBlok _ => const Placeholder(),
    };
  }
}
