import 'package:flutter_test/flutter_test.dart';
import 'package:hue_messenger/core/mock/mock_repo.dart';

void main() {
  group('Profile settings', () {
    test('updates current user name, status, and avatar', () {
      final repo = MockRepository.seeded();

      repo.updateCurrentUserName('  Cihat  ');
      repo.updateCurrentUserStatus('Fokus modundayim');
      repo.updateCurrentUserAvatar(MockRepository.avatarPresets.first);

      final user = repo.getCurrentUser();
      expect(user.name, 'Cihat');
      expect(user.status, 'Fokus modundayim');
      expect(user.avatarUrl, MockRepository.avatarPresets.first);

      repo.updateCurrentUserStatus('   ');
      repo.updateCurrentUserAvatar(null);

      final updatedUser = repo.getCurrentUser();
      expect(updatedUser.status, isNull);
      expect(updatedUser.avatarUrl, isNull);
    });

    test('validates display name input', () {
      final repo = MockRepository.seeded();

      expect(() => repo.updateCurrentUserName('   '), throwsFormatException);
      expect(() => repo.updateCurrentUserName('a' * 25), throwsFormatException);
    });

    test('updates toggle style preferences', () {
      final repo = MockRepository.seeded();

      repo.setProfilePhotoVisible(false);
      repo.setReadReceiptsEnabled(false);
      repo.setTypingIndicatorEnabled(false);
      repo.setQuietHoursEnabled(true);

      expect(repo.getProfilePhotoVisible(), isFalse);
      expect(repo.getReadReceiptsEnabled(), isFalse);
      expect(repo.getTypingIndicatorEnabled(), isFalse);
      expect(repo.getQuietHoursEnabled(), isTrue);
    });
  });
}
