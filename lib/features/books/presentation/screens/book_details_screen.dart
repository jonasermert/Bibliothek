import 'package:bibliothek/features/books/domain/book.dart';
import 'package:bibliothek/features/books/presentation/providers/book_providers.dart';
import 'package:bibliothek/features/books/presentation/widgets/book_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookDetailsScreen extends ConsumerWidget {
  const BookDetailsScreen({required this.book, super.key});
  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = ref.watch(favoritesProvider).value?.any((b) => b.key == book.key) ?? false;
    return Scaffold(
      appBar: AppBar(actions: [IconButton(onPressed: () => ref.read(favoritesProvider.notifier).toggle(book), icon: Icon(favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded))]),
      body: ListView(padding: const EdgeInsets.fromLTRB(24, 8, 24, 40), children: [
        Center(child: Hero(tag: book.key, child: BookCover(url: book.coverUrl, width: 190, height: 285))),
        const SizedBox(height: 28),
        Text(book.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(book.authorLine, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Center(child: RatingBarIndicator(rating: (book.ratingsAverage ?? 0).clamp(0, 5).toDouble(), itemBuilder: (context, index) => const Icon(Icons.star_rounded, color: Color(0xFFFFC857)), itemSize: 28)),
        const SizedBox(height: 26),
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _Fact(label: 'Erstveröffentlichung', value: '${book.firstPublishYear ?? '–'}'),
          _Fact(label: 'Ausgaben', value: '${book.editionCount}'),
          _Fact(label: 'Bewertungen', value: '${book.ratingsCount}'),
        ]))),
        if (book.subjects.isNotEmpty) ...[
          const SizedBox(height: 28),
          Text('Themen', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: book.subjects.map((item) => Chip(label: Text(item))).toList()),
        ],
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: () => ref.read(favoritesProvider.notifier).toggle(book),
          icon: Icon(favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
          label: Text(favorite ? 'Aus Favoriten entfernen' : 'Zu Favoriten hinzufügen'),
        ),
      ]),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [Text(value, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 4), Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall)]));
}
