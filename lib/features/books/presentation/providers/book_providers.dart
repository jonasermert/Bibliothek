import 'dart:async';
import 'dart:convert';
import 'package:bibliothek/core/network/dio_provider.dart';
import 'package:bibliothek/features/books/data/book_repository.dart';
import 'package:bibliothek/features/books/domain/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final bookRepositoryProvider = Provider((ref) => BookRepository(ref.watch(dioProvider)));
final trendingBooksProvider = FutureProvider((ref) => ref.watch(bookRepositoryProvider).trending());

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchBooksProvider = FutureProvider.autoDispose<List<Book>>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.length < 2) return const [];
  await Future<void>.delayed(const Duration(milliseconds: 450));
  if (query != ref.read(searchQueryProvider).trim()) return const [];
  return ref.watch(bookRepositoryProvider).search(query);
});

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, List<Book>>(FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<List<Book>> {
  static const _key = 'favorite_books';

  @override
  Future<List<Book>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_key) ?? const [];
    final books = <Book>[];
    for (final value in values) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          books.add(Book.fromJson(decoded));
        }
      } on FormatException {
        // Ignore individual corrupt entries instead of breaking all favorites.
      }
    }
    return books;
  }

  Future<void> toggle(Book book) async {
    final current = state.value ?? const <Book>[];
    final exists = current.any((item) => item.key == book.key);
    final updated = exists ? current.where((item) => item.key != book.key).toList() : [...current, book];
    state = AsyncData(updated);
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = await prefs.setStringList(
        _key,
        updated.map((item) => jsonEncode(item.toJson())).toList(),
      );
      if (!saved) {
        throw StateError('Favoriten konnten nicht gespeichert werden.');
      }
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  bool contains(Book book) => state.value?.any((item) => item.key == book.key) ?? false;
}
