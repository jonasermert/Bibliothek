import 'package:bibliothek/core/widgets/async_error_view.dart';
import 'package:bibliothek/features/books/presentation/providers/book_providers.dart';
import 'package:bibliothek/features/books/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(trendingBooksProvider);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(trendingBooksProvider.future),
      child: CustomScrollView(slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
          sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.local_library_rounded)),
              const Spacer(),
              IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
            ]),
            const SizedBox(height: 24),
            Text('Deine digitale\nBibliothek', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Entdecke Klassiker, Bestseller und neue Lieblingsbücher.', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Text('Beliebte Bücher', style: Theme.of(context).textTheme.titleLarge),
          ])),
        ),
        books.when(
          loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
          error: (error, _) => SliverFillRemaining(child: AsyncErrorView(message: 'Die Bücher konnten nicht geladen werden.', onRetry: () => ref.invalidate(trendingBooksProvider))),
          data: (items) => SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.separated(itemCount: items.length, itemBuilder: (_, i) => BookCard(book: items[i]), separatorBuilder: (context, index) => const SizedBox(height: 12)),
          ),
        ),
      ]),
    );
  }
}
