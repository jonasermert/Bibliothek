import 'package:bibliothek/features/books/presentation/providers/book_providers.dart';
import 'package:bibliothek/features/books/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    return CustomScrollView(slivers: [
      const SliverAppBar.large(title: Text('Favoriten'), automaticallyImplyLeading: false),
      favorites.when(
        loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
        error: (error, stackTrace) => const SliverFillRemaining(child: Center(child: Text('Favoriten konnten nicht geladen werden.'))),
        data: (books) => books.isEmpty
            ? SliverFillRemaining(hasScrollBody: false, child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.favorite_border_rounded, size: 72, color: Theme.of(context).colorScheme.primary), const SizedBox(height: 12), Text('Noch keine Favoriten', style: Theme.of(context).textTheme.titleLarge)])))
            : SliverPadding(padding: const EdgeInsets.all(20), sliver: SliverList.separated(itemCount: books.length, itemBuilder: (_, i) => BookCard(book: books[i]), separatorBuilder: (context, index) => const SizedBox(height: 12))),
      ),
    ]);
  }
}
