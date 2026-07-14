import 'package:bibliothek/features/books/domain/book.dart';
import 'package:bibliothek/features/books/presentation/screens/book_details_screen.dart';
import 'package:bibliothek/features/books/presentation/screens/library_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LibraryShell(),
      routes: [
        GoRoute(
          path: 'book',
          builder: (context, state) {
            final book = state.extra;
            if (book is! Book) {
              return const _MissingBookScreen();
            }
            return BookDetailsScreen(book: book);
          },
        ),
      ],
    ),
  ],
);


class _MissingBookScreen extends StatelessWidget {
  const _MissingBookScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buch nicht gefunden')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FilledButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_rounded),
            label: const Text('Zur Startseite'),
          ),
        ),
      ),
    );
  }
}
