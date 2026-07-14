import 'package:bibliothek/features/books/domain/book.dart';
import 'package:dio/dio.dart';

class BookRepository {
  BookRepository(this._dio);
  final Dio _dio;

  Future<List<Book>> search(String query, {int page = 1, int limit = 20}) async {
    final response = await _dio.get<Map<String, dynamic>>('/search.json', queryParameters: {
      'q': query,
      'page': page,
      'limit': limit,
      'fields': 'key,title,author_name,first_publish_year,cover_i,edition_count,ratings_average,ratings_count,subject,isbn',
    });
    final docs = response.data?['docs'] as List? ?? const [];
    return docs.whereType<Map<String, dynamic>>().map(Book.fromJson).toList();
  }

  Future<List<Book>> trending() => search('subject:fiction', limit: 12);
}
