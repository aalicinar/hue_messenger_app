import '../models/hue_category.dart';

class RateLimitService {
  final Map<_RateLimitKey, DateTime> _lastSentAtByKey = {};

  bool canSend({
    required String senderId,
    required String recipientId,
    required HueCategory category,
    required Duration interval,
    DateTime? now,
  }) {
    if (interval <= Duration.zero) return true;

    final current = now ?? DateTime.now();
    final key = _RateLimitKey(senderId, recipientId, category);
    final lastSentAt = _lastSentAtByKey[key];
    if (lastSentAt == null) return true;

    return current.difference(lastSentAt) >= interval;
  }

  Duration timeUntilNextAllowed({
    required String senderId,
    required String recipientId,
    required HueCategory category,
    required Duration interval,
    DateTime? now,
  }) {
    if (interval <= Duration.zero) return Duration.zero;

    final current = now ?? DateTime.now();
    final key = _RateLimitKey(senderId, recipientId, category);
    final lastSentAt = _lastSentAtByKey[key];
    if (lastSentAt == null) return Duration.zero;

    final elapsed = current.difference(lastSentAt);
    if (elapsed >= interval) return Duration.zero;
    return interval - elapsed;
  }

  void recordSent({
    required String senderId,
    required String recipientId,
    required HueCategory category,
    DateTime? at,
  }) {
    final key = _RateLimitKey(senderId, recipientId, category);
    _lastSentAtByKey[key] = at ?? DateTime.now();
  }
}

class _RateLimitKey {
  const _RateLimitKey(this.senderId, this.recipientId, this.category);

  final String senderId;
  final String recipientId;
  final HueCategory category;

  @override
  bool operator ==(Object other) {
    return other is _RateLimitKey &&
        other.senderId == senderId &&
        other.recipientId == recipientId &&
        other.category == category;
  }

  @override
  int get hashCode => Object.hash(senderId, recipientId, category);
}
