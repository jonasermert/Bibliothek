import 'package:bibliothek/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Bibliothek app starts successfully', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(
        child: BibliothekApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Deine digitale\nBibliothek'), findsOneWidget);
    expect(find.text('Beliebte Bücher'), findsOneWidget);
  });
}
