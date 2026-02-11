import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hue_messenger/app/app.dart';

void main() {
  testWidgets('shows Hue Box as default tab', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HueApp()));
    // Pump a few extra frames for animations and font loading
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Hue Box'), findsWidgets);
    expect(find.text('Sohbetler'), findsWidgets);
    expect(find.text('Ayarlar'), findsWidgets);
  });
}
