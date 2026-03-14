import 'package:flutter_test/flutter_test.dart';
import 'package:lume_lucy_paperwall/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const LumeLucyApp());
    expect(find.text('开始探索'), findsOneWidget);
  });
}
