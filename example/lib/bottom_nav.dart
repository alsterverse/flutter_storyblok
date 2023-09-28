import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';

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
        unselectedItemColor: Color.fromARGB(109, 255, 255, 255),
        onTap: (value) => _onTap(value),
        items: widget.bottomNav.pages.map((page) {
          final sp = (page as bloks.BottomNavPage);
          return BottomNavigationBarItem(
            icon: switch (sp.icon) {
              bloks.Icons.start => const Icon(Icons.table_rows_rounded),
              bloks.Icons.search => const Icon(Icons.search),
              bloks.Icons.blocks => const Icon(Icons.square),
              bloks.Icons.unknown => const Icon(Icons.abc),
            },
            label: sp.label,
          );
        }).toList(),
        currentIndex: _selectedIndex,
      ),
      body: IndexedStack(
          index: _selectedIndex,
          children: widget.bottomNav.pages
              .map(
                (e) => e.buildWidget(context),
              )
              .toList()),
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
