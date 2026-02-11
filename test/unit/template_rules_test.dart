import 'package:flutter_test/flutter_test.dart';
import 'package:hue_messenger/core/mock/mock_repo.dart';
import 'package:hue_messenger/core/models/hue_category.dart';

void main() {
  group('Template rules', () {
    test('rejects emoji in template text', () {
      final repo = MockRepository.seeded();

      expect(
        () => repo.addCustomTemplate(
          category: HueCategory.red,
          text: 'Acil doner misin 😊',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('enforces max 10 custom templates per category', () {
      final repo = MockRepository.seeded();

      for (var i = 0; i < 10; i++) {
        repo.addCustomTemplate(
          category: HueCategory.yellow,
          text: 'Custom yellow $i',
        );
      }

      expect(
        () => repo.addCustomTemplate(
          category: HueCategory.yellow,
          text: 'Custom yellow overflow',
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
