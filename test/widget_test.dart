import 'package:flutter_test/flutter_test.dart';
import 'package:phenixal/phenixal_app.dart';

void main() {
  testWidgets('PhenixalApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PhenixalApp());
    await tester.pump();
    expect(find.text('Phenixal Trail Explorer'), findsWidgets);
  });
}
