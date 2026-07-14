import 'package:bibliothek/features/books/domain/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Book.fromJson', () {
    test('maps normal Open Library data', () {
      final book = Book.fromJson({
        'key': '/works/OL1W',
        'title': 'Atomic Habits',
        'author_name': ['James Clear'],
        'cover_i': 123,
        'ratings_average': 4.5,
        'isbn': ['1234567890'],
      });

      expect(book.title, 'Atomic Habits');
      expect(book.authorLine, 'James Clear');
      expect(book.coverUrl, contains('/123-L.jpg'));
      expect(book.isbn, '1234567890');
    });

    test('handles missing and loosely typed values safely', () {
      final book = Book.fromJson({
        'title': '  Testbuch  ',
        'first_publish_year': '2024',
        'edition_count': 3.0,
        'ratings_average': '4.25',
        'ratings_count': '17',
        'author_name': [42, 'Autor'],
      });

      expect(book.key, startsWith('local-'));
      expect(book.title, 'Testbuch');
      expect(book.authors, ['Autor']);
      expect(book.firstPublishYear, 2024);
      expect(book.editionCount, 3);
      expect(book.ratingsAverage, 4.25);
      expect(book.ratingsCount, 17);
    });

    test('serializes favorites data for local persistence', () {
      final source = Book.fromJson({
        'key': '/works/OL2W',
        'title': 'Clean Code',
        'author_name': ['Robert C. Martin'],
        'subject': ['Software engineering'],
        'isbn': ['9780132350884'],
      });

      final restored = Book.fromJson(source.toJson());

      expect(restored.key, source.key);
      expect(restored.title, source.title);
      expect(restored.authors, source.authors);
      expect(restored.subjects, source.subjects);
      expect(restored.isbn, source.isbn);
    });
  });
}
