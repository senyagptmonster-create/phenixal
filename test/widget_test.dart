import 'package:flutter_test/flutter_test.dart';
import 'package:phenixal/phenixal_app.dart';

void main() {
  testWidgets('PhenixalApp root smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PhenixalApp());
    expect(find.byType(PhenixalApp), findsOneWidget);
  });
}