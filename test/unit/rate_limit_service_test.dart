import 'package:flutter_test/flutter_test.dart';
import 'package:hue_messenger/core/models/hue_category.dart';
import 'package:hue_messenger/core/services/rate_limit_service.dart';

void main() {
  group('RateLimitService', () {
    test('allows first send for a key', () {
      final service = RateLimitService();
      final allowed = service.canSend(
        senderId: 'alice',
        recipientId: 'me',
        category: HueCategory.red,
        interval: const Duration(minutes: 10),
        now: DateTime(2026, 2, 11, 20, 0),
      );

      expect(allowed, isTrue);
    });

    test('blocks sends within interval for same sender/recipient/category', () {
      final service = RateLimitService();
      final start = DateTime(2026, 2, 11, 20, 0);

      service.recordSent(
        senderId: 'alice',
        recipientId: 'me',
        category: HueCategory.yellow,
        at: start,
      );

      final allowed = service.canSend(
        senderId: 'alice',
        recipientId: 'me',
        category: HueCategory.yellow,
        interval: const Duration(minutes: 30),
        now: start.add(const Duration(minutes: 10)),
      );

      expect(allowed, isFalse);
    });

    test('returns remaining wait time correctly', () {
      final service = RateLimitService();
      final start = DateTime(2026, 2, 11, 20, 0);

      service.recordSent(
        senderId: 'alice',
        recipientId: 'me',
        category: HueCategory.green,
        at: start,
      );

      final remaining = service.timeUntilNextAllowed(
        senderId: 'alice',
        recipientId: 'me',
        category: HueCategory.green,
        interval: const Duration(minutes: 5),
        now: start.add(const Duration(minutes: 3)),
      );

      expect(remaining, const Duration(minutes: 2));
    });

    test('different category uses independent key', () {
      final service = RateLimitService();
      final start = DateTime(2026, 2, 11, 20, 0);

      service.recordSent(
        senderId: 'alice',
        recipientId: 'me',
        category: HueCategory.red,
        at: start,
      );

      final allowed = service.canSend(
        senderId: 'alice',
        recipientId: 'me',
        category: HueCategory.blue,
        interval: const Duration(hours: 1),
        now: start.add(const Duration(minutes: 1)),
      );

      expect(allowed, isTrue);
    });

    test('zero interval is always allowed', () {
      final service = RateLimitService();
      final start = DateTime(2026, 2, 11, 20, 0);

      service.recordSent(
        senderId: 'alice',
        recipientId: 'me',
        category: HueCategory.blue,
        at: start,
      );

      final allowed = service.canSend(
        senderId: 'alice',
        recipientId: 'me',
        category: HueCategory.blue,
        interval: Duration.zero,
        now: start.add(const Duration(seconds: 1)),
      );

      expect(allowed, isTrue);
    });
  });
}
