import 'dart:async';

import 'package:example/article_overview_page.dart';
import 'package:example/article_page_screen.dart';
import 'package:example/banner.dart';
import 'package:example/banner_reference.dart';
import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/category.dart';
import 'package:example/components/colors.dart';
import 'package:example/featured_articles_section.dart';
import 'package:example/form_section.dart';
import 'package:example/grid_card.dart';
import 'package:example/grid_section.dart';
import 'package:example/hero_section.dart';
import 'package:example/image_text_section.dart';
import 'package:example/splash_screen.dart';
import 'package:example/tabbed_content_entry.dart';
import 'package:example/tabbed_content_section.dart';
import 'package:example/text_section.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart' as sb;
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:example/starter_blocks/page.dart' as starter_blocks;

const rootPageId = 494819167;
const accessToken = "fBBGMz5rR5Jvc0F71v8X2Qtt";

final storyblokClient = sb.StoryblokClient<bloks.Blok>(
  accessToken: accessToken, // Demo app
  version: sb.ContentVersion.draft,
  storyContentBuilder: (json) => bloks.Blok.fromJson(json),
);

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

final router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) {
      final slug = state.uri.queryParameters["slug"];

      if (slug != null) {
        return FutureStoryWidget(
          storyFuture: storyblokClient.getStory(
            id: sb.StoryIdentifierFullSlug(slug),
            resolveLinks: sb.ResolveLinks.story,
          ),
        );
      }

      return FutureStoryWidget(
        storyFuture: storyblokClient.getStory(
          id: const sb.StoryIdentifierID(rootPageId),
          resolveLinks: sb.ResolveLinks.story,
        ),
        delayed: true,
      );
    },
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter x Storyblok',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          elevation: 0,
          titleTextStyle:
              TextStyle(fontSize: 20.0, color: AppColors.white, fontWeight: FontWeight.w700, letterSpacing: -2),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.black,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, color: AppColors.black, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontSize: 14.0, color: AppColors.black, fontWeight: FontWeight.w400),
          bodySmall: TextStyle(fontSize: 12.0, color: AppColors.black, fontWeight: FontWeight.w400),
          headlineLarge: TextStyle(fontSize: 24.0, color: AppColors.black, fontWeight: FontWeight.w900),
          headlineMedium: TextStyle(fontSize: 20.0, color: AppColors.black, fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(fontSize: 16.0, color: AppColors.black, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class FutureStoryWidget extends StatelessWidget {
  final Future<sb.Story<bloks.Blok>> storyFuture;
  final bool delayed;
  const FutureStoryWidget({
    super.key,
    required this.storyFuture,
    this.delayed = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        storyFuture,
        if (delayed) Future.delayed(const Duration(milliseconds: 500)),
      ]),
      builder: (context, snapshot) {
        final story = snapshot.data?.first as sb.Story<bloks.Blok>?;
        if (story != null) {
          return story.content.buildWidget(context);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }
        return const Scaffold(
          body: SplashScreen(),
        );
      },
    );
  }
}

extension BlockWidget on bloks.Blok {
  Widget buildWidget(BuildContext context) {
    return Center(
      child: switch (this) {
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
        bloks.UnrecognizedBlok blok => Text(blok.toString()),
        //TODO: remove this line before release
        _ => kDebugMode ? const Placeholder() : const SizedBox.shrink(),
      },
    );
  }
}
