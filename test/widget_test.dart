import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petconnect_ai/main.dart';

void main() {
  testWidgets('PetConnectApp initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PetConnectApp(),
      ),
    );

    expect(find.byType(PetConnectApp), findsOneWidget);
  });
}
