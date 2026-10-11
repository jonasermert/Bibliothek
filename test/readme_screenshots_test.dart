import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:bibliothek/core/theme/app_theme.dart';
import 'package:bibliothek/core/widgets/curved_bottom_navigation_bar.dart';
import 'package:bibliothek/features/books/domain/book.dart';
import 'package:bibliothek/features/books/presentation/providers/book_providers.dart';
import 'package:bibliothek/features/books/presentation/screens/library_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final books = [
  Book.fromJson({
    'key': '/works/demo-pride',
    'title': 'Pride and Prejudice',
    'author_name': ['Jane Austen'],
    'first_publish_year': 1813,
    'edition_count': 120,
  }),
  Book.fromJson({
    'key': '/works/demo-frankenstein',
    'title': 'Frankenstein',
    'author_name': ['Mary Shelley'],
    'first_publish_year': 1818,
    'edition_count': 86,
  }),
  Book.fromJson({
    'key': '/works/demo-sherlock',
    'title': 'The Adventures of Sherlock Holmes',
    'author_name': ['Arthur Conan Doyle'],
    'first_publish_year': 1892,
    'edition_count': 94,
  }),
];

void main() {
  testWidgets('capture actual library screens for README', (tester) async {
    await tester.runAsync(() async {
      final flutterUri = await Isolate.resolvePackageUri(
        Uri.parse('package:flutter/material.dart'),
      );
      final sdk = File.fromUri(flutterUri!).parent.parent.parent.parent;
      for (final font in [
        ('Roboto', 'Roboto-Regular.ttf'),
        ('Roboto', 'Roboto-Bold.ttf'),
        ('MaterialIcons', 'MaterialIcons-Regular.otf'),
      ]) {
        final loader = FontLoader(font.$1);
        loader.addFont(
          File(
            '${sdk.path}/bin/cache/artifacts/material_fonts/${font.$2}',
          ).readAsBytes().then(ByteData.sublistView),
        );
        await loader.load();
      }
    });
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({
      'favorite_books': [jsonEncode(books.first.toJson())],
    });
    final boundaryKey = GlobalKey();
    final container = ProviderContainer(
      overrides: [trendingBooksProvider.overrideWith((ref) async => books)],
    );
    addTearDown(container.dispose);
    Future<void> mount(ThemeData theme) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: RepaintBoundary(
            key: boundaryKey,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              home: const LibraryShell(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> capture(String name) async {
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await tester.runAsync(() async {
        await File(
          'screenshots/$name.png',
        ).writeAsBytes(bytes!.buffer.asUint8List());
        final encoded = base64Encode(bytes.buffer.asUint8List());
        final parts = (encoded.length / 8000).ceil();
        for (var part = 0; part < parts; part++) {
          final end = ((part + 1) * 8000).clamp(0, encoded.length);
          stdout.writeln(
            'README_IMAGE:$name:$part:$parts:${encoded.substring(part * 8000, end)}',
          );
        }
      });
      image.dispose();
    }

    Future<void> select(String label) async {
      await tester.tap(
        find.descendant(
          of: find.byType(CurvedBottomNavigationBar),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
    }

    await mount(AppTheme.light);
    await capture('discover-curved-light');
    await select('Suche');
    await capture('search-curved-light');
    await mount(AppTheme.dark);
    await select('Favoriten');
    await capture('favorites-curved-dark');
    await select('Einstellungen');
    await capture('settings-curved-dark');
    expect(tester.takeException(), isNull);
  });
}
