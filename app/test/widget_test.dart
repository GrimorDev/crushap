// Smoke test: with no server configured yet, the app boots straight to
// the server-setup step (it can't reach onboarding/login without one).

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crushap/main.dart';

void main() {
  testWidgets('Crushap boots to server setup when unconfigured', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const CrushapApp());
    await tester.pumpAndSettle();

    expect(find.text('Connect to your server'), findsOneWidget);
  });
}
