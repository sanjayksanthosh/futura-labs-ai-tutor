import 'package:flutter_test/flutter_test.dart';
import 'package:futura_labs_ai_tutor/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FuturaLabsAiTutorApp());
    await tester.pump();
  });
}
