import 'package:flutter_test/flutter_test.dart';

import 'package:life_leveling/main.dart';

void main() {
  testWidgets('App builds without throwing', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeLevelingApp());
    await tester.pump();

    // Smoke test: the app builds and renders (shows loading spinner
    // while it reads data from storage) without throwing.
    expect(find.byType(LifeLevelingApp), findsOneWidget);
  });
}
