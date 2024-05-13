import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/flutter_storyblok.dart';

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
    const backgroundColor = AppColors.black;
    const selectedItemColor = AppColors.primary;
    final unselectedItemColor = AppColors.primary.withOpacity(0.5);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: backgroundColor,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: (value) => _onTap(value),
        items: widget.bottomNav.items
            .map((item) => BottomNavigationBarItem(
                  backgroundColor: backgroundColor,
                  label: item.label,
                  activeIcon: Image.network(
                    item.icon.fileName,
                    color: selectedItemColor,
                    width: 40,
                    height: 40,
                  ),
                  icon: Image.network(
                    item.icon.fileName,
                    color: unselectedItemColor,
                    width: 40,
                    height: 40,
                  ),
                ))
            .toList(),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.bottomNav.items.map((item) {
          final page = item.page;
          if (page is LinkTypeStory) {
            final content = page.resolvedStory?.content;
            if (content is bloks.Blok) return content.buildWidget(context);
          }
          return const Placeholder();
        }).toList(),
      ),
    );
  }
}
