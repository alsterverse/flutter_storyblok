import 'dart:async';

import 'package:example/block_widget_builder.dart';
import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/colors.dart';
import 'package:example/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart' as sb;
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

const rootPageId = 494819167;
const accessToken = "fBBGMz5rR5Jvc0F71v8X2Qtt";

final storyblokClient = sb.StoryblokClient(
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
