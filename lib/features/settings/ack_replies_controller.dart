import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/mock/mock_repo.dart';

final ackRepliesControllerProvider =
    StateNotifierProvider<AckRepliesController, List<String>>((ref) {
      final repository = ref.watch(mockRepositoryProvider);
      final controller = AckRepliesController(repository)..load();
      final sub = repository.watchRevision().listen((_) {
        controller.load();
      });
      ref.onDispose(sub.cancel);
      return controller;
    });

class AckRepliesController extends StateNotifier<List<String>> {
  AckRepliesController(this._repository) : super(const <String>[]);

  final MockRepository _repository;

  void load() {
    state = _repository.getAckReplies();
  }

  String? addReply(String value) {
    try {
      _repository.addAckReply(value);
      return null;
    } on StateError catch (error) {
      return error.message;
    } on FormatException catch (error) {
      return error.message;
    }
  }

  String? updateReplyAt({required int index, required String value}) {
    try {
      _repository.updateAckReplyAt(index: index, text: value);
      return null;
    } on StateError catch (error) {
      return error.message;
    } on FormatException catch (error) {
      return error.message;
    }
  }

  String? removeReplyAt(int index) {
    try {
      _repository.removeAckReplyAt(index);
      return null;
    } on StateError catch (error) {
      return error.message;
    }
  }
}
