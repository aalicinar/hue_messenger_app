import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/mock/mock_repo.dart';
import '../../core/models/chat.dart';

class ChatsState {
  const ChatsState({required this.chats, this.searchQuery = ''});

  final List<Chat> chats;
  final String searchQuery;

  List<Chat> get filteredChats {
    if (searchQuery.isEmpty) return chats;
    final query = searchQuery.toLowerCase();
    return chats.where((chat) {
      final preview = (chat.lastPreview ?? '').toLowerCase();
      final memberNames = chat.memberIds.join(' ').toLowerCase();
      return preview.contains(query) || memberNames.contains(query);
    }).toList();
  }

  ChatsState copyWith({List<Chat>? chats, String? searchQuery}) {
    return ChatsState(
      chats: chats ?? this.chats,
      searchQuery: searchQuery ?? this.searchQuery,
    );
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

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
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
