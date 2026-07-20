// Smoke test: the app boots to the onboarding welcome step.

import 'package:flutter_test/flutter_test.dart';

import 'package:crushap/main.dart';

void main() {
  testWidgets('Crushap boots to onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const CrushapApp());
    await tester.pump();

    expect(find.text('crushap'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
