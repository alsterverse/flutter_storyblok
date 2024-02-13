import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/link_type.dart';

class BottomNavigation extends StatefulWidget {
  final bloks.BottomNavigation bottomNav;
  const BottomNavigation({super.key, required this.bottomNav});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.black,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor: const Color.fromARGB(255, 144, 84, 255),
        unselectedItemColor: const Color.fromARGB(109, 255, 255, 255),
        onTap: (value) => _onTap(value),
        items: widget.bottomNav.items.map((page) {
          return BottomNavigationBarItem(
            activeIcon: Image.network(
              page.icon.fileName,
              color: const Color.fromARGB(255, 144, 84, 255),
              width: 44,
              height: 44,
            ),
            icon: Image.network(
              page.icon.fileName,
              color: const Color.fromARGB(109, 255, 255, 255),
              width: 40,
              height: 40,
            ),
            label: page.label,
          );
        }).toList(),
        currentIndex: _selectedIndex,
      ),
      body: IndexedStack(
          index: _selectedIndex,
          children: widget.bottomNav.items.map((item) {
            if (((item.page as LinkTypeStory).resolvedStory?.content is bloks.Page)) {
              var story = (item.page as LinkTypeStory).resolvedStory;
              return Scaffold(
                appBar: AppBar(title: Text(story?.name ?? "No content")),
                body: Center(
                  child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(24),
                      children: ((item.page as LinkTypeStory).resolvedStory?.content as bloks.Page)
                          .body
                          .map((e) => e.buildWidget(context))
                          .separatedBy(() => const SizedBox(height: 24))
                          .toList()),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(title: Text((item.page as LinkTypeStory).resolvedStory?.name ?? "name is null")),
                body: Center(child: Text(item.label)),
              );
            }
          }).toList()),
    );
  }
}

class BottomNavigationPage extends StatelessWidget {
  final bloks.BottomNavPage bottomNavPage;
  const BottomNavigationPage({super.key, required this.bottomNavPage});

  @override
  Widget build(BuildContext context) {
    return bottomNavPage.block.buildWidget(context);
  }
}
