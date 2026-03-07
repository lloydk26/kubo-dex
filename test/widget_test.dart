import 'package:flutter_test/flutter_test.dart';
import 'package:kubo_dex/features/app/presentation/views/init_app.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const InitApp());
    expect(find.text('Kubo Dex'), findsOneWidget);
  });
}
