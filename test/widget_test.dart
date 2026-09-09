import 'package:flutter_test/flutter_test.dart';

import 'package:campusmarket/main.dart';

void main() {
  testWidgets('CampusMarket app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CampusMarketApp());

    // Verify that the placeholder home screen is displayed.
    expect(find.text('CampusMarket 🚀'), findsOneWidget);
  });
}
