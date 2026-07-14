import 'package:bibliothek/features/books/presentation/screens/home_screen.dart';
import 'package:bibliothek/features/books/presentation/screens/search_screen.dart';
import 'package:bibliothek/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:bibliothek/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class LibraryShell extends StatefulWidget {
  const LibraryShell({super.key});

  @override
  State<LibraryShell> createState() => _LibraryShellState();
}

class _LibraryShellState extends State<LibraryShell> {
  int index = 0;

  static const pages = [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: [
            for (var pageIndex = 0; pageIndex < pages.length; pageIndex++)
              HeroMode(
                enabled: pageIndex == index,
                child: pages[pageIndex],
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories_rounded),
            label: 'Entdecken',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Suche',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favoriten',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Einstellungen',
          ),
        ],
      ),
    );
  }
}
