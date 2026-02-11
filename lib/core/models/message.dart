import 'hue_category.dart';

enum MessageType { normal, hue }

class Message {
  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.type,
    required this.createdAt,
    this.text,
    this.category,
    this.templateText,
    this.acknowledgedAt,
    this.acknowledgedText,
  });

  final String id;
  final String chatId;
  final String senderId;
  final String recipientId;
  final MessageType type;
  final String? text;
  final HueCategory? category;
  final String? templateText;
  final DateTime createdAt;
  final DateTime? acknowledgedAt;
  final String? acknowledgedText;

  bool get isUnacked => type == MessageType.hue && acknowledgedAt == null;

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? recipientId,
    MessageType? type,
    String? text,
    HueCategory? category,
    String? templateText,
    DateTime? createdAt,
    DateTime? acknowledgedAt,
    String? acknowledgedText,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      type: type ?? this.type,
      text: text ?? this.text,
      category: category ?? this.category,
      templateText: templateText ?? this.templateText,
      createdAt: createdAt ?? this.createdAt,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      acknowledgedText: acknowledgedText ?? this.acknowledgedText,
    );
  }
}
