import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storyblok/story.dart';

class BottomNavigationPage extends StatefulWidget {
  final List<Story> stories;
  const BottomNavigationPage({super.key, required this.stories});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
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
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.lightBlue,
        onTap: (value) => _onTap(value),
        items: widget.stories
            .map((story) => BottomNavigationBarItem(
                  icon: const Icon(Icons.abc),
                  label: story.name,
                ))
            .toList(),
        currentIndex: _selectedIndex,
      ),
      body: IndexedStack(
          index: _selectedIndex,
          children: widget.stories
              .map(
                (e) => bloks.Blok.fromJson(e.content).buildWidget(context),
              )
              .toList()),
    );
  }
}
