import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hue_messenger/app/app.dart';
import 'package:hue_messenger/shared/widgets/hue_logo.dart';

void main() {
  testWidgets('shows splash content on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HueApp()));
    // Pump a few extra frames for animations and font loading.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(HueLogo), findsOneWidget);
    expect(find.text('Hue Messenger'), findsNothing);
    expect(find.text('Feel your messages'), findsNothing);

    // Let splash timer finish to avoid pending timer assertions.
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();
  });
}
