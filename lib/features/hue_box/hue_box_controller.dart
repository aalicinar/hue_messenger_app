import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/mock/mock_repo.dart';
import '../../core/models/hue_category.dart';
import '../../core/models/message.dart';
import 'hue_box_sort.dart';

enum HueBoxFilter { all, red, yellow, green, blue }

extension HueBoxFilterX on HueBoxFilter {
  HueCategory? get category {
    switch (this) {
      case HueBoxFilter.all:
        return null;
      case HueBoxFilter.red:
        return HueCategory.red;
      case HueBoxFilter.yellow:
        return HueCategory.yellow;
      case HueBoxFilter.green:
        return HueCategory.green;
      case HueBoxFilter.blue:
        return HueCategory.blue;
    }
  }

  String get label {
    switch (this) {
      case HueBoxFilter.all:
        return 'Tümü';
      case HueBoxFilter.red:
        return 'Kırmızı';
      case HueBoxFilter.yellow:
        return 'Sarı';
      case HueBoxFilter.green:
        return 'Yeşil';
      case HueBoxFilter.blue:
        return 'Mavi';
    }
  }
}

class HueBoxState {
  const HueBoxState({
    required this.selectedFilter,
    required this.hueMessages,
    required this.ackReplies,
  });

  final HueBoxFilter selectedFilter;
  final List<Message> hueMessages;
  final List<String> ackReplies;

  List<Message> get filteredMessages {
    final category = selectedFilter.category;
    if (category == null) return hueMessages;

    return hueMessages
        .where((message) => message.category == category)
        .toList();
  }

  HueBoxState copyWith({
    HueBoxFilter? selectedFilter,
    List<Message>? hueMessages,
    List<String>? ackReplies,
  }) {
    return HueBoxState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      hueMessages: hueMessages ?? this.hueMessages,
      ackReplies: ackReplies ?? this.ackReplies,
    );
  }
}

final hueBoxControllerProvider =
    StateNotifierProvider<HueBoxController, HueBoxState>((ref) {
      final repository = ref.watch(mockRepositoryProvider);
      final controller = HueBoxController(repository)..load();
      final sub = repository.watchRevision().listen((_) {
        controller.load();
      });
      ref.onDispose(sub.cancel);
      return controller;
    });

class HueBoxController extends StateNotifier<HueBoxState> {
  HueBoxController(this._repository)
    : super(
        const HueBoxState(
          selectedFilter: HueBoxFilter.all,
          hueMessages: [],
          ackReplies: [],
        ),
      );

  final MockRepository _repository;

  void load() {
    final inbox = _repository.getHueInboxForUser(MockRepository.currentUserId);
    state = state.copyWith(
      hueMessages: sortHueBoxItems(inbox),
      ackReplies: _repository.getAckReplies(),
    );
  }

  void setFilter(HueBoxFilter filter) {
    if (state.selectedFilter == filter) return;
    state = state.copyWith(selectedFilter: filter);
  }

  void acknowledge(String messageId, {String? replyText}) {
    _repository.acknowledgeHueMessage(messageId, replyText: replyText);
    load();
  }
}
