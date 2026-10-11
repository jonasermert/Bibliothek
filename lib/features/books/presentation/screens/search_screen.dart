import 'package:bibliothek/core/widgets/async_error_view.dart';
import 'package:bibliothek/features/books/presentation/providers/book_providers.dart';
import 'package:bibliothek/features/books/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final result = ref.watch(searchBooksProvider);
    return CustomScrollView(slivers: [
      const SliverAppBar.large(title: Text('Bücher suchen'), automaticallyImplyLeading: false),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        sliver: SliverToBoxAdapter(child: TextField(
          onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Titel, Autor oder ISBN …'),
        )),
      ),
      if (query.trim().length < 2)
        const SliverFillRemaining(hasScrollBody: false, child: _EmptySearch())
      else
        result.when(
          loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => SliverFillRemaining(child: AsyncErrorView(message: 'Bei der Suche ist ein Fehler aufgetreten.', onRetry: () => ref.invalidate(searchBooksProvider))),
          data: (books) => books.isEmpty
              ? const SliverFillRemaining(hasScrollBody: false, child: Center(child: Text('Keine passenden Bücher gefunden.')))
              : SliverPadding(padding: const EdgeInsets.all(20), sliver: SliverList.separated(itemCount: books.length, itemBuilder: (_, i) => BookCard(book: books[i]), separatorBuilder: (context, index) => const SizedBox(height: 12))),
        ),
    ]);
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();
  @override
  Widget build(BuildContext context) => Center(child: Padding(
    padding: const EdgeInsets.all(32),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.manage_search_rounded, size: 72, color: Theme.of(context).colorScheme.primary),
      const SizedBox(height: 16),
      Text('Was möchtest du lesen?', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      const Text('Gib mindestens zwei Zeichen ein. Die Suche verwendet den offenen Katalog von Open Library.', textAlign: TextAlign.center),
    ]),
  ));
}
