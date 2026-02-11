import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/mock/mock_repo.dart';
import '../../core/models/hue_category.dart';
import '../../core/models/template.dart';

class TemplatesState {
  const TemplatesState({
    required this.selectedCategory,
    required this.templates,
  });

  final HueCategory selectedCategory;
  final List<Template> templates;

  TemplatesState copyWith({
    HueCategory? selectedCategory,
    List<Template>? templates,
  }) {
    return TemplatesState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      templates: templates ?? this.templates,
    );
  }
}

final templatesControllerProvider =
    StateNotifierProvider<TemplatesController, TemplatesState>((ref) {
      final repository = ref.watch(mockRepositoryProvider);
      final controller = TemplatesController(repository)..load();
      final sub = repository.watchRevision().listen((_) {
        controller.load();
      });
      ref.onDispose(sub.cancel);
      return controller;
    });

class TemplatesController extends StateNotifier<TemplatesState> {
  TemplatesController(this._repository)
    : super(
        const TemplatesState(selectedCategory: HueCategory.red, templates: []),
      );

  final MockRepository _repository;

  void load() {
    state = state.copyWith(
      templates: _repository.getTemplatesForCategory(state.selectedCategory),
    );
  }

  void setCategory(HueCategory category) {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: category);
    load();
  }

  String? addTemplate(String text) {
    try {
      _repository.addCustomTemplate(
        category: state.selectedCategory,
        text: text,
      );
      return null;
    } on StateError catch (error) {
      return error.message;
    } on FormatException catch (error) {
      return error.message;
    }
  }

  String? updateTemplate({required String templateId, required String text}) {
    try {
      _repository.updateCustomTemplate(templateId: templateId, text: text);
      return null;
    } on StateError catch (error) {
      return error.message;
    } on FormatException catch (error) {
      return error.message;
    }
  }

  String? deleteTemplate(String templateId) {
    try {
      _repository.deleteCustomTemplate(templateId);
      return null;
    } on StateError catch (error) {
      return error.message;
    }
  }

  bool canAddInSelectedCategory() {
    return _repository.canAddCustomTemplate(state.selectedCategory);
  }

  int customCountInSelectedCategory() {
    final category = state.selectedCategory;
    return state.templates
        .where(
          (template) => template.category == category && !template.isDefault,
        )
        .length;
  }
}
