import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/mock/mock_repo.dart';
import '../../core/models/hue_category.dart';
import '../../core/models/rate_limits.dart';

final rateLimitsControllerProvider =
    StateNotifierProvider<RateLimitsController, RateLimits>((ref) {
      final repository = ref.watch(mockRepositoryProvider);
      final controller = RateLimitsController(repository)..load();
      final sub = repository.watchRevision().listen((_) {
        controller.load();
      });
      ref.onDispose(sub.cancel);
      return controller;
    });

class RateLimitsController extends StateNotifier<RateLimits> {
  RateLimitsController(this._repository)
    : super(
        const RateLimits(
          redSeconds: 3600,
          yellowSeconds: 1800,
          greenSeconds: 300,
          blueSeconds: 0,
        ),
      );

  final MockRepository _repository;

  void load() {
    state = _repository.getRateLimits();
  }

  void updateCategory({required HueCategory category, required int seconds}) {
    final updated = switch (category) {
      HueCategory.red => state.copyWith(redSeconds: seconds),
      HueCategory.yellow => state.copyWith(yellowSeconds: seconds),
      HueCategory.green => state.copyWith(greenSeconds: seconds),
      HueCategory.blue => state.copyWith(blueSeconds: seconds),
    };
    _repository.updateRateLimits(updated);
  }
}
