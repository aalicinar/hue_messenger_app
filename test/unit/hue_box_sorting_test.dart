import 'package:flutter_test/flutter_test.dart';
import 'package:hue_messenger/core/models/hue_category.dart';
import 'package:hue_messenger/core/models/message.dart';
import 'package:hue_messenger/features/hue_box/hue_box_sort.dart';

void main() {
  group('Hue Box sorting', () {
    test('puts all unacked hue messages before acked messages', () {
      final now = DateTime(2026, 2, 11, 20);
      final sorted = sortHueBoxItems([
        _hueMessage(
          id: 'acked1',
          category: HueCategory.red,
          createdAt: now,
          acked: true,
        ),
        _hueMessage(
          id: 'unacked1',
          category: HueCategory.blue,
          createdAt: now.subtract(const Duration(minutes: 1)),
        ),
        _hueMessage(
          id: 'unacked2',
          category: HueCategory.green,
          createdAt: now.subtract(const Duration(minutes: 2)),
        ),
      ]);

      expect(sorted.take(2).every((message) => message.isUnacked), isTrue);
      expect(sorted.last.id, 'acked1');
    });

    test(
      'applies category priority for unacked: red > yellow > green > blue',
      () {
        final now = DateTime(2026, 2, 11, 20);
        final sorted = sortHueBoxItems([
          _hueMessage(
            id: 'blue',
            category: HueCategory.blue,
            createdAt: now.subtract(const Duration(minutes: 1)),
          ),
          _hueMessage(
            id: 'green',
            category: HueCategory.green,
            createdAt: now.subtract(const Duration(minutes: 2)),
          ),
          _hueMessage(
            id: 'yellow',
            category: HueCategory.yellow,
            createdAt: now.subtract(const Duration(minutes: 3)),
          ),
          _hueMessage(
            id: 'red',
            category: HueCategory.red,
            createdAt: now.subtract(const Duration(minutes: 4)),
          ),
        ]);

        expect(
          sorted.map((message) => message.id).toList(),
          equals(['red', 'yellow', 'green', 'blue']),
        );
      },
    );

    test('sorts newest first within same category bucket', () {
      final now = DateTime(2026, 2, 11, 20);
      final sorted = sortHueBoxItems([
        _hueMessage(
          id: 'older',
          category: HueCategory.red,
          createdAt: now.subtract(const Duration(minutes: 10)),
        ),
        _hueMessage(
          id: 'newer',
          category: HueCategory.red,
          createdAt: now.subtract(const Duration(minutes: 2)),
        ),
      ]);

      expect(sorted.first.id, 'newer');
      expect(sorted.last.id, 'older');
    });

    test('sorts acked messages newest first after all unacked', () {
      final now = DateTime(2026, 2, 11, 20);
      final sorted = sortHueBoxItems([
        _hueMessage(
          id: 'acked_old',
          category: HueCategory.red,
          createdAt: now.subtract(const Duration(hours: 1)),
          acked: true,
        ),
        _hueMessage(
          id: 'acked_new',
          category: HueCategory.blue,
          createdAt: now.subtract(const Duration(minutes: 5)),
          acked: true,
        ),
        _hueMessage(
          id: 'unacked',
          category: HueCategory.green,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      ]);

      expect(sorted.first.id, 'unacked');
      expect(sorted[1].id, 'acked_new');
      expect(sorted[2].id, 'acked_old');
    });

    test('keeps ordering rules stable with 40 messages', () {
      final now = DateTime(2026, 2, 11, 20);
      final batch = <Message>[];
      var i = 0;
      for (final category in HueCategory.values) {
        for (var j = 0; j < 8; j++) {
          batch.add(
            _hueMessage(
              id: 'u_${category.name}_$j',
              category: category,
              createdAt: now.subtract(Duration(minutes: i++)),
            ),
          );
        }
      }

      for (var j = 0; j < 8; j++) {
        batch.add(
          _hueMessage(
            id: 'a_$j',
            category: HueCategory.blue,
            createdAt: now.subtract(Duration(hours: j)),
            acked: true,
          ),
        );
      }

      final sorted = sortHueBoxItems(batch);
      final unacked = sorted.where((message) => message.isUnacked).toList();
      final acked = sorted.where((message) => !message.isUnacked).toList();

      expect(unacked.length, 32);
      expect(acked.length, 8);
      expect(sorted.take(32).every((message) => message.isUnacked), isTrue);
      expect(sorted.skip(32).every((message) => !message.isUnacked), isTrue);

      final firstRedIndex = unacked.indexWhere(
        (message) => message.category == HueCategory.red,
      );
      final firstYellowIndex = unacked.indexWhere(
        (message) => message.category == HueCategory.yellow,
      );
      final firstGreenIndex = unacked.indexWhere(
        (message) => message.category == HueCategory.green,
      );
      final firstBlueIndex = unacked.indexWhere(
        (message) => message.category == HueCategory.blue,
      );

      expect(firstRedIndex, lessThan(firstYellowIndex));
      expect(firstYellowIndex, lessThan(firstGreenIndex));
      expect(firstGreenIndex, lessThan(firstBlueIndex));
    });
  });
}

Message _hueMessage({
  required String id,
  required HueCategory category,
  required DateTime createdAt,
  bool acked = false,
}) {
  return Message(
    id: id,
    chatId: 'chat',
    senderId: 'alice',
    recipientId: 'current',
    type: MessageType.hue,
    category: category,
    templateText: 'template',
    createdAt: createdAt,
    acknowledgedAt: acked ? createdAt.add(const Duration(minutes: 1)) : null,
  );
}
