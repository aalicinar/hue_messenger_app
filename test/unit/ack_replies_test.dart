import 'package:flutter_test/flutter_test.dart';
import 'package:hue_messenger/core/mock/mock_repo.dart';

void main() {
  group('Ack replies', () {
    test('starts with default options', () {
      final repo = MockRepository.seeded();

      expect(repo.getAckReplies(), const ['Tamam', 'Evet', 'Hayır']);
    });

    test('enforces max 3 options and at least 1 option', () {
      final repo = MockRepository.seeded();

      expect(() => repo.addAckReply('Belki'), throwsA(isA<StateError>()));

      repo.removeAckReplyAt(2);
      repo.removeAckReplyAt(1);

      expect(repo.getAckReplies(), const ['Tamam']);
      expect(() => repo.removeAckReplyAt(0), throwsA(isA<StateError>()));
    });

    test('stores selected reply text when acknowledging', () {
      final repo = MockRepository.seeded();

      repo.acknowledgeHueMessage('m2', replyText: 'Evet');
      final message = repo
          .getMessagesForChat('chat_alice')
          .firstWhere((item) => item.id == 'm2');

      expect(message.acknowledgedAt, isNotNull);
      expect(message.acknowledgedText, 'Evet');
    });

    test('stores custom reply text when acknowledging', () {
      final repo = MockRepository.seeded();

      repo.acknowledgeHueMessage('m2', replyText: 'Toplantiya giriyorum');
      final message = repo
          .getMessagesForChat('chat_alice')
          .firstWhere((item) => item.id == 'm2');

      expect(message.acknowledgedAt, isNotNull);
      expect(message.acknowledgedText, 'Toplantiya giriyorum');
    });

    test('uses first configured option as default acknowledge reply', () {
      final repo = MockRepository.seeded();

      repo.acknowledgeHueMessage('m4');
      final message = repo
          .getMessagesForChat('chat_bob')
          .firstWhere((item) => item.id == 'm4');

      expect(message.acknowledgedText, 'Tamam');
    });
  });
}
