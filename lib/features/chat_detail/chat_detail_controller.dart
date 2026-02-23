import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/mock/mock_repo.dart';
import '../../core/models/template.dart';
import '../../core/models/message.dart';

class ChatDetailState {
  const ChatDetailState({
    required this.chatId,
    required this.title,
    required this.recipientId,
    required this.messages,
    required this.ackReplies,
  });

  final String chatId;
  final String title;
  final String recipientId;
  final List<Message> messages;
  final List<String> ackReplies;

  ChatDetailState copyWith({
    String? chatId,
    String? title,
    String? recipientId,
    List<Message>? messages,
    List<String>? ackReplies,
  }) {
    return ChatDetailState(
      chatId: chatId ?? this.chatId,
      title: title ?? this.title,
      recipientId: recipientId ?? this.recipientId,
      messages: messages ?? this.messages,
      ackReplies: ackReplies ?? this.ackReplies,
    );
  }
}

final chatDetailControllerProvider =
    StateNotifierProvider.family<ChatDetailController, ChatDetailState, String>(
      (ref, chatId) {
        final repository = ref.watch(mockRepositoryProvider);
        final controller = ChatDetailController(
          repository: repository,
          chatId: chatId,
        )..load();
        final sub = repository.watchRevision().listen((_) {
          controller.load();
        });
        ref.onDispose(sub.cancel);
        return controller;
      },
    );

class ChatDetailController extends StateNotifier<ChatDetailState> {
  ChatDetailController({
    required MockRepository repository,
    required String chatId,
  }) : _repository = repository,
       super(
         ChatDetailState(
           chatId: chatId,
           title: '',
           recipientId: '',
           messages: const [],
           ackReplies: const [],
         ),
       );

  final MockRepository _repository;

  void load() {
    final chat = _repository.getChatById(state.chatId);
    if (chat == null) return;

    var recipientId = MockRepository.currentUserId;
    for (final memberId in chat.memberIds) {
      if (memberId != MockRepository.currentUserId) {
        recipientId = memberId;
        break;
      }
    }

    final recipientName = _repository.getUserById(recipientId)?.name ?? '';
    final messages = _repository.getMessagesForChat(state.chatId);

    state = state.copyWith(
      title: recipientName,
      recipientId: recipientId,
      messages: messages,
      ackReplies: _repository.getAckReplies(),
    );
  }

  void sendNormalMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.recipientId.isEmpty) return;

    _repository.sendNormalMessage(
      chatId: state.chatId,
      senderId: MockRepository.currentUserId,
      recipientId: state.recipientId,
      text: trimmed,
    );
    load();
  }

  HueSendResult sendHueMessage(Template template) {
    if (state.recipientId.isEmpty) return HueSendResult.blocked(Duration.zero);

    final result = _repository.sendHueMessage(
      chatId: state.chatId,
      senderId: MockRepository.currentUserId,
      recipientId: state.recipientId,
      category: template.category,
      templateText: template.text,
    );
    return result;
  }

  void acknowledgeHue(String messageId, {String? replyText}) {
    _repository.acknowledgeHueMessage(messageId, replyText: replyText);
    load();
  }
}
