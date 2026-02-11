import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/mock/mock_repo.dart';
import '../../core/models/chat.dart';

class ChatsState {
  const ChatsState({required this.chats});

  final List<Chat> chats;

  ChatsState copyWith({List<Chat>? chats}) {
    return ChatsState(chats: chats ?? this.chats);
  }
}

final chatsControllerProvider =
    StateNotifierProvider<ChatsController, ChatsState>((ref) {
  final repository = ref.watch(mockRepositoryProvider);
  final controller = ChatsController(repository)..load();
  final sub = repository.watchRevision().listen((_) {
    controller.load();
  });
  ref.onDispose(sub.cancel);
  return controller;
});

class ChatsController extends StateNotifier<ChatsState> {
  ChatsController(this._repository) : super(const ChatsState(chats: []));

  final MockRepository _repository;

  void load() {
    state = state.copyWith(
      chats: _repository.getChatsForUser(MockRepository.currentUserId),
    );
  }

  String createOrGetChatWith(String otherUserId) {
    final chat = _repository.createOrGetChat(
      currentUserId: MockRepository.currentUserId,
      otherUserId: otherUserId,
    );
    load();
    return chat.id;
  }
}
