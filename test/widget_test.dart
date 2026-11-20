import 'package:activity_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Opens the add activity form from the main screen', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Dodaj aktywność'));
    await tester.pumpAndSettle();

    expect(find.text('Nowa aktywność'), findsOneWidget);
    expect(find.text('Nazwa aktywności'), findsOneWidget);
  });
}
