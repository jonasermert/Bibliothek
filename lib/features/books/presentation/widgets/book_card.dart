import 'package:bibliothek/features/books/domain/book.dart';
import 'package:bibliothek/features/books/presentation/providers/book_providers.dart';
import 'package:bibliothek/features/books/presentation/widgets/book_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookCard extends ConsumerWidget {
  const BookCard({required this.book, super.key});
  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = ref.watch(favoritesProvider).value?.any((b) => b.key == book.key) ?? false;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => context.push('/book', extra: book),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Hero(tag: book.key, child: BookCover(url: book.coverUrl)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(book.authorLine, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              RatingBarIndicator(
                rating: (book.ratingsAverage ?? 0).clamp(0, 5).toDouble(),
                itemBuilder: (context, index) => const Icon(Icons.star_rounded, color: Color(0xFFFFC857)),
                itemSize: 18,
              ),
              const SizedBox(height: 10),
              Wrap(spacing: 8, children: [
                if (book.firstPublishYear != null) Chip(label: Text('${book.firstPublishYear}'), visualDensity: VisualDensity.compact),
                Chip(label: Text('${book.editionCount} Ausgaben'), visualDensity: VisualDensity.compact),
              ]),
            ])),
            IconButton(
              tooltip: favorite ? 'Aus Favoriten entfernen' : 'Als Favorit speichern',
              onPressed: () => ref.read(favoritesProvider.notifier).toggle(book),
              icon: Icon(favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
            ),
          ]),
        ),
      ),
    );
  }
}
