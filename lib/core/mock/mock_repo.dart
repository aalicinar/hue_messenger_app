import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/chat.dart';
import '../models/hue_category.dart';
import '../models/message.dart';
import '../models/rate_limits.dart';
import '../models/template.dart';
import '../models/user.dart';
import '../services/rate_limit_service.dart';
import 'mock_seed.dart';

final mockRepositoryProvider = Provider<MockRepository>((ref) {
  final repository = MockRepository.seeded();
  ref.onDispose(repository.dispose);
  return repository;
});

class HueSendResult {
  const HueSendResult._({
    required this.sent,
    this.message,
    this.retryAfter = Duration.zero,
  });

  factory HueSendResult.sent(Message message) {
    return HueSendResult._(sent: true, message: message);
  }

  factory HueSendResult.blocked(Duration retryAfter) {
    return HueSendResult._(sent: false, retryAfter: retryAfter);
  }

  final bool sent;
  final Message? message;
  final Duration retryAfter;
}

class MockRepository {
  MockRepository.seeded()
    : _users = List<User>.from(MockSeed.users()),
      _chats = List<Chat>.from(MockSeed.chats()),
      _messages = List<Message>.from(MockSeed.messages()),
      _templates = List<Template>.from(MockSeed.templates()),
      _rateLimits = MockSeed.rateLimits(),
      _ackReplies = List<String>.from(MockSeed.ackReplies());

  static const currentUserId = 'current';
  static const List<String> avatarPresets = <String>[
    'preset:spectrum',
    'preset:ember',
    'preset:amber',
    'preset:mint',
    'preset:sky',
  ];

  final List<User> _users;
  final List<Chat> _chats;
  final List<Message> _messages;
  final List<Template> _templates;
  RateLimits _rateLimits;
  final List<String> _ackReplies;
  bool _readReceiptsEnabled = true;
  bool _typingIndicatorEnabled = true;
  bool _quietHoursEnabled = false;
  bool _profilePhotoVisible = true;
  final Uuid _uuid = const Uuid();
  final RateLimitService _rateLimitService = RateLimitService();
  final StreamController<int> _revisionController =
      StreamController<int>.broadcast();
  int _revision = 0;

  Stream<int> watchRevision() => _revisionController.stream;

  void dispose() {
    _revisionController.close();
  }

  List<User> getUsers() => List.unmodifiable(_users);

  User getCurrentUser() =>
      _users.firstWhere((user) => user.id == currentUserId);

  void updateCurrentUserName(String name) {
    final normalized = name.trim();
    if (normalized.isEmpty) {
      throw FormatException('Display name cannot be empty.');
    }
    if (normalized.length > 24) {
      throw FormatException('Display name must be 24 characters or fewer.');
    }
    _updateCurrentUser((current) => current.copyWith(name: normalized));
  }

  void updateCurrentUserStatus(String status) {
    final normalized = status.trim();
    if (normalized.length > 40) {
      throw FormatException('Status must be 40 characters or fewer.');
    }
    _updateCurrentUser((current) {
      if (normalized.isEmpty) return current.copyWith(clearStatus: true);
      return current.copyWith(status: normalized);
    });
  }

  void updateCurrentUserAvatar(String? avatarAsset) {
    if (avatarAsset != null && !avatarPresets.contains(avatarAsset)) {
      throw StateError('Unsupported avatar preset.');
    }
    _updateCurrentUser((current) {
      if (avatarAsset == null) return current.copyWith(clearAvatarUrl: true);
      return current.copyWith(avatarUrl: avatarAsset);
    });
  }

  bool getReadReceiptsEnabled() => _readReceiptsEnabled;

  bool getTypingIndicatorEnabled() => _typingIndicatorEnabled;

  bool getQuietHoursEnabled() => _quietHoursEnabled;

  bool getProfilePhotoVisible() => _profilePhotoVisible;

  void setReadReceiptsEnabled(bool value) {
    if (_readReceiptsEnabled == value) return;
    _readReceiptsEnabled = value;
    _emitRevision();
  }

  void setTypingIndicatorEnabled(bool value) {
    if (_typingIndicatorEnabled == value) return;
    _typingIndicatorEnabled = value;
    _emitRevision();
  }

  void setQuietHoursEnabled(bool value) {
    if (_quietHoursEnabled == value) return;
    _quietHoursEnabled = value;
    _emitRevision();
  }

  void setProfilePhotoVisible(bool value) {
    if (_profilePhotoVisible == value) return;
    _profilePhotoVisible = value;
    _emitRevision();
  }

  User? getUserById(String id) {
    for (final user in _users) {
      if (user.id == id) return user;
    }
    return null;
  }

  List<Chat> getChatsForUser(String userId) {
    final chats = _chats
        .where((chat) => chat.memberIds.contains(userId))
        .toList();
    chats.sort((a, b) {
      final aTime = a.lastAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.lastAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return chats;
  }

  Chat? getChatById(String chatId) {
    for (final chat in _chats) {
      if (chat.id == chatId) return chat;
    }
    return null;
  }

  Chat createOrGetChat({
    required String currentUserId,
    required String otherUserId,
  }) {
    for (final chat in _chats) {
      final members = chat.memberIds;
      if (members.length != 2) continue;
      if (members.contains(currentUserId) && members.contains(otherUserId)) {
        return chat;
      }
    }

    final newChat = Chat(
      id: 'chat_${_uuid.v4()}',
      memberIds: [currentUserId, otherUserId],
      lastPreview: null,
      lastAt: DateTime.now(),
    );
    _chats.add(newChat);
    _emitRevision();
    return newChat;
  }

  List<Message> getMessagesForChat(String chatId) {
    return _messages.where((message) => message.chatId == chatId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Message sendNormalMessage({
    required String chatId,
    required String senderId,
    required String recipientId,
    required String text,
  }) {
    final now = DateTime.now();
    final message = Message(
      id: 'msg_${_uuid.v4()}',
      chatId: chatId,
      senderId: senderId,
      recipientId: recipientId,
      type: MessageType.normal,
      text: text,
      createdAt: now,
    );
    _messages.add(message);
    _updateChatPreview(chatId: chatId, preview: text, timestamp: now);
    _emitRevision();
    return message;
  }

  HueSendResult sendHueMessage({
    required String chatId,
    required String senderId,
    required String recipientId,
    required HueCategory category,
    required String templateText,
  }) {
    final interval = Duration(seconds: _rateLimits.secondsFor(category));
    final canSend = _rateLimitService.canSend(
      senderId: senderId,
      recipientId: recipientId,
      category: category,
      interval: interval,
    );

    if (!canSend) {
      final retryAfter = _rateLimitService.timeUntilNextAllowed(
        senderId: senderId,
        recipientId: recipientId,
        category: category,
        interval: interval,
      );
      return HueSendResult.blocked(retryAfter);
    }

    final now = DateTime.now();
    final message = Message(
      id: 'hue_${_uuid.v4()}',
      chatId: chatId,
      senderId: senderId,
      recipientId: recipientId,
      type: MessageType.hue,
      category: category,
      templateText: templateText,
      createdAt: now,
    );
    _messages.add(message);
    _updateChatPreview(
      chatId: chatId,
      preview: 'H: $templateText',
      timestamp: now,
    );
    _rateLimitService.recordSent(
      senderId: senderId,
      recipientId: recipientId,
      category: category,
      at: now,
    );
    _emitRevision();
    return HueSendResult.sent(message);
  }

  List<Message> getHueInboxForUser(String userId, {HueCategory? category}) {
    return _messages.where((message) {
      if (message.type != MessageType.hue) return false;
      if (message.recipientId != userId) return false;
      if (category != null && message.category != category) return false;
      return true;
    }).toList();
  }

  void acknowledgeHueMessage(String messageId, {String? replyText}) {
    final index = _messages.indexWhere((message) => message.id == messageId);
    if (index == -1) return;

    final message = _messages[index];
    if (message.type != MessageType.hue || message.acknowledgedAt != null) {
      return;
    }

    final selectedReply = _normalizeReply(replyText ?? _ackReplies.first);
    _messages[index] = message.copyWith(
      acknowledgedAt: DateTime.now(),
      acknowledgedText: selectedReply,
    );
    _emitRevision();
  }

  List<Template> getTemplates() => List.unmodifiable(_templates);

  List<Template> getTemplatesForCategory(HueCategory category) {
    final templates = _templates
        .where(
          (template) => template.category == category && !template.isHidden,
        )
        .toList();
    templates.sort((a, b) => a.order.compareTo(b.order));
    return templates;
  }

  bool canAddCustomTemplate(HueCategory category) {
    final customCount = _templates
        .where(
          (template) => template.category == category && !template.isDefault,
        )
        .length;
    return customCount < 10;
  }

  Template addCustomTemplate({
    required HueCategory category,
    required String text,
  }) {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      throw FormatException('Template cannot be empty.');
    }
    if (_containsEmoji(normalized)) {
      throw FormatException('Emoji is not allowed in Hue templates.');
    }
    if (!canAddCustomTemplate(category)) {
      throw StateError('Maximum 10 custom templates allowed per category.');
    }

    var maxOrder = -1;
    for (final template in _templates) {
      if (template.category != category) continue;
      if (template.order > maxOrder) maxOrder = template.order;
    }

    final template = Template(
      id: 'tpl_${_uuid.v4()}',
      category: category,
      text: normalized,
      isDefault: false,
      isHidden: false,
      order: maxOrder + 1,
    );
    _templates.add(template);
    _emitRevision();
    return template;
  }

  Template updateCustomTemplate({
    required String templateId,
    required String text,
  }) {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      throw FormatException('Template cannot be empty.');
    }
    if (_containsEmoji(normalized)) {
      throw FormatException('Emoji is not allowed in Hue templates.');
    }

    final index = _templates.indexWhere(
      (template) => template.id == templateId,
    );
    if (index == -1) throw StateError('Template not found.');

    final current = _templates[index];
    if (current.isDefault) {
      throw StateError('Default templates cannot be edited.');
    }

    final updated = current.copyWith(text: normalized);
    _templates[index] = updated;
    _emitRevision();
    return updated;
  }

  void deleteCustomTemplate(String templateId) {
    final index = _templates.indexWhere(
      (template) => template.id == templateId,
    );
    if (index == -1) throw StateError('Template not found.');

    if (_templates[index].isDefault) {
      throw StateError('Default templates cannot be deleted.');
    }

    _templates.removeAt(index);
    _emitRevision();
  }

  RateLimits getRateLimits() => _rateLimits;

  void updateRateLimits(RateLimits newLimits) {
    _rateLimits = newLimits;
    _emitRevision();
  }

  List<String> getAckReplies() => List.unmodifiable(_ackReplies);

  void addAckReply(String text) {
    if (_ackReplies.length >= 3) {
      throw StateError('You can define up to 3 reply options.');
    }

    final normalized = _normalizeReply(text);
    if (_ackReplies.contains(normalized)) {
      throw StateError('Reply option already exists.');
    }

    _ackReplies.add(normalized);
    _emitRevision();
  }

  void updateAckReplyAt({required int index, required String text}) {
    if (index < 0 || index >= _ackReplies.length) {
      throw StateError('Reply option not found.');
    }

    final normalized = _normalizeReply(text);
    final duplicateIndex = _ackReplies.indexOf(normalized);
    if (duplicateIndex != -1 && duplicateIndex != index) {
      throw StateError('Reply option already exists.');
    }

    _ackReplies[index] = normalized;
    _emitRevision();
  }

  void removeAckReplyAt(int index) {
    if (index < 0 || index >= _ackReplies.length) {
      throw StateError('Reply option not found.');
    }
    if (_ackReplies.length <= 1) {
      throw StateError('At least one reply option is required.');
    }

    _ackReplies.removeAt(index);
    _emitRevision();
  }

  void _updateChatPreview({
    required String chatId,
    required String preview,
    required DateTime timestamp,
  }) {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index == -1) return;

    _chats[index] = _chats[index].copyWith(
      lastPreview: preview,
      lastAt: timestamp,
    );
  }

  void _updateCurrentUser(User Function(User current) updater) {
    final index = _users.indexWhere((user) => user.id == currentUserId);
    if (index == -1) return;
    _users[index] = updater(_users[index]);
    _emitRevision();
  }

  void _emitRevision() {
    if (_revisionController.isClosed) return;
    _revision += 1;
    _revisionController.add(_revision);
  }

  bool _containsEmoji(String input) {
    final emojiRegex = RegExp(
      r'[\u{1F300}-\u{1FAFF}\u{2600}-\u{27BF}]',
      unicode: true,
    );
    return emojiRegex.hasMatch(input);
  }

  String _normalizeReply(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw FormatException('Reply text cannot be empty.');
    }
    if (normalized.length > 24) {
      throw FormatException('Reply text must be 24 characters or fewer.');
    }
    return normalized;
  }
}
