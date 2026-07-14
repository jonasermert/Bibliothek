class Book {
  const Book({
    required this.key,
    required this.title,
    required this.authors,
    required this.firstPublishYear,
    required this.coverId,
    required this.editionCount,
    required this.ratingsAverage,
    required this.ratingsCount,
    required this.subjects,
    required this.isbn,
  });

  final String key;
  final String title;
  final List<String> authors;
  final int? firstPublishYear;
  final int? coverId;
  final int editionCount;
  final double? ratingsAverage;
  final int ratingsCount;
  final List<String> subjects;
  final String? isbn;

  String get authorLine => authors.isEmpty
      ? 'Unbekannte Autorin / unbekannter Autor'
      : authors.join(', ');

  String? get coverUrl => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> strings(String key) =>
        (json[key] as List?)?.whereType<String>().toList() ?? const [];

    int? integer(String key) {
      final value = json[key];
      return switch (value) {
        int number => number,
        num number => number.toInt(),
        String text => int.tryParse(text),
        _ => null,
      };
    }

    double? decimal(String key) {
      final value = json[key];
      return switch (value) {
        num number => number.toDouble(),
        String text => double.tryParse(text),
        _ => null,
      };
    }

    final title = json['title'];
    final rawKey = json['key'];
    final normalizedTitle = title is String && title.trim().isNotEmpty
        ? title.trim()
        : 'Unbekannter Titel';

    return Book(
      key: rawKey is String && rawKey.isNotEmpty
          ? rawKey
          : 'local-${normalizedTitle.hashCode}',
      title: normalizedTitle,
      authors: strings('author_name'),
      firstPublishYear: integer('first_publish_year'),
      coverId: integer('cover_i'),
      editionCount: integer('edition_count') ?? 0,
      ratingsAverage: decimal('ratings_average'),
      ratingsCount: integer('ratings_count') ?? 0,
      subjects: strings('subject').take(8).toList(growable: false),
      isbn: strings('isbn').firstOrNull,
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'title': title,
        'author_name': authors,
        'first_publish_year': firstPublishYear,
        'cover_i': coverId,
        'edition_count': editionCount,
        'ratings_average': ratingsAverage,
        'ratings_count': ratingsCount,
        'subject': subjects,
        if (isbn != null) 'isbn': [isbn],
      };
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
