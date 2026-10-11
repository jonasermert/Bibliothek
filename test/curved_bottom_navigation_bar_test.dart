import 'package:bibliothek/core/widgets/curved_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const destinations = [
  NavigationDestination(icon: Icon(Icons.book), label: 'Entdecken'),
  NavigationDestination(icon: Icon(Icons.search), label: 'Suche'),
  NavigationDestination(icon: Icon(Icons.favorite), label: 'Favoriten'),
  NavigationDestination(icon: Icon(Icons.settings), label: 'Einstellungen'),
];

Widget harness({
  required ValueChanged<int> onSelected,
  TextDirection direction = TextDirection.ltr,
  Brightness brightness = Brightness.light,
  double textScale = 1,
}) => MaterialApp(
  theme: ThemeData(brightness: brightness),
  home: Directionality(
    textDirection: direction,
    child: MediaQuery(
      data: MediaQueryData(
        textScaler: TextScaler.linear(textScale),
        padding: const EdgeInsets.only(bottom: 24),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
            bottomNavigationBar: CurvedBottomNavigationBar(
              selectedIndex: 0,
              onDestinationSelected: onSelected,
              destinations: destinations,
            ),
          );
        },
      ),
    ),
  ),
);

void main() {
  testWidgets('tapping each tab reports its destination', (tester) async {
    final selections = <int>[];
    await tester.pumpWidget(harness(onSelected: selections.add));
    for (final destination in destinations) {
      await tester.tap(find.text(destination.label));
      await tester.pumpAndSettle();
    }
    expect(selections, [0, 1, 2, 3]);
  });

  for (final direction in TextDirection.values) {
    testWidgets('drag snaps to the correct tab in $direction', (tester) async {
      final selections = <int>[];
      await tester.pumpWidget(
        harness(onSelected: selections.add, direction: direction),
      );
      final start = tester.getCenter(find.byIcon(Icons.book));
      final end = tester.getCenter(find.byIcon(Icons.settings));
      final gesture = await tester.startGesture(start);
      await gesture.moveTo(
        Offset(start.dx + (end.dx - start.dx) / 2, start.dy),
      );
      await tester.pump();
      await gesture.moveTo(end);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(selections, [3]);
    });
  }

  testWidgets('selected tab has accessible label and selection state', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(harness(onSelected: (_) {}));
    expect(
      tester.getSemantics(find.bySemanticsLabel('Entdecken')),
      matchesSemantics(
        label: 'Entdecken',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('small screens and large text fit in both themes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final brightness in Brightness.values) {
      await tester.pumpWidget(
        harness(onSelected: (_) {}, brightness: brightness, textScale: 2),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(CurvedBottomNavigationBar), findsOneWidget);
    }
  });
}
