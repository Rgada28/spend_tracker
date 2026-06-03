import 'package:flutter_test/flutter_test.dart';
import 'package:spend_tracker/main.dart';

void main() {
  testWidgets('App smoke test — SpendTrackerApp renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SpendTrackerApp());
    await tester.pump();
    expect(find.byType(SpendTrackerApp), findsOneWidget);
  });
}
