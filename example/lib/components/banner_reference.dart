import 'dart:async';
import 'package:example/components/banner.dart';
import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/colors.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';

class BannerReferenceWidget extends StatefulWidget {
  const BannerReferenceWidget(this.blok, {super.key});

  final bloks.BannerReference blok;

  @override
  State<BannerReferenceWidget> createState() => _BannerReferenceWidgetState();
}

class _BannerReferenceWidgetState extends State<BannerReferenceWidget> {
  final pageController = PageController();
  final pageNotifier = ValueNotifier(0);

  void showNextSlide() {
    if (pageController.hasClients) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(widget.blok.banners.map((id) => storyblokClient.getStory(id: id))),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final bannerList = snapshot.data?.map((story) => story.content as bloks.Banner).toList();

        if (bannerList == null) return Text(snapshot.error.toString());

        return Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 500,
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (value) => setState(() {
                      pageNotifier.value = value;
                    }),
                    itemCount: bannerList.length,
                    itemBuilder: (context, index) {
                      return BannerWidget(bannerList[index]);
                    },
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder(
                    valueListenable: pageNotifier,
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(bannerList.length, (index) {
                        return InkWell(
                          onTap: () {
                            pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.all(4.0),
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.secondary, width: 2),
                              color: pageController.hasClients && pageController.page?.round() == index
                                  ? AppColors.secondary
                                  : AppColors.light,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
        // return BannerWidget(banner);
      },
    );
  }
}
