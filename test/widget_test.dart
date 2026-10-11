import 'package:bibliothek/app/app.dart';
import 'package:bibliothek/core/widgets/curved_bottom_navigation_bar.dart';
import 'package:bibliothek/features/books/domain/book.dart';
import 'package:bibliothek/features/books/presentation/providers/book_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Bibliothek app starts successfully', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          trendingBooksProvider.overrideWith((ref) async => const <Book>[]),
        ],
        child: const BibliothekApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Deine digitale\nBibliothek'), findsOneWidget);
    expect(find.text('Beliebte Bücher'), findsOneWidget);

    final bar = find.byType(CurvedBottomNavigationBar);
    await tester.tap(find.descendant(of: bar, matching: find.text('Suche')));
    await tester.pumpAndSettle();
    expect(find.text('Was möchtest du lesen?'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(of: bar, matching: find.text('Favoriten')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Noch keine Favoriten'), findsOneWidget);

    await tester.tap(
      find.descendant(of: bar, matching: find.text('Einstellungen')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Systemeinstellung'), findsOneWidget);

    await tester.tap(find.descendant(of: bar, matching: find.text('Suche')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      'a',
    );

    await tester.tap(
      find.descendant(of: bar, matching: find.text('Entdecken')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Deine digitale\nBibliothek'), findsOneWidget);
  });
}
