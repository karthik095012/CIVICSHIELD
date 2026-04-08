import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:civicshield/main.dart';

void main() {
  testWidgets('CivicShield app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CivicShieldApp()));
    await tester.pump();
    expect(find.byType(CivicShieldApp), findsOneWidget);
  });
}
