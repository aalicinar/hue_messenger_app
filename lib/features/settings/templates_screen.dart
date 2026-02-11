import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../core/models/hue_category.dart';
import '../../core/models/template.dart';
import '../../shared/widgets/hue_backdrop.dart';
import '../../shared/widgets/hue_category_badge.dart';
import 'templates_controller.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templatesControllerProvider);
    final controller = ref.read(templatesControllerProvider.notifier);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Şablonlar')),
      child: HueBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(HueSpacing.md),
            child: Column(
              children: [
                HueGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoSegmentedControl<HueCategory>(
                        groupValue: state.selectedCategory,
                        children: {
                          for (final category in HueCategory.values)
                            category: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: HueSpacing.sm,
                                vertical: HueSpacing.xs,
                              ),
                              child: HueCategoryBadge(
                                category: category,
                                size: 24,
                                isSelected: state.selectedCategory == category,
                              ),
                            ),
                        },
                        onValueChanged: controller.setCategory,
                      ),
                      const SizedBox(height: HueSpacing.sm),
                      Text(
                        'Özel şablon: ${controller.customCountInSelectedCategory()}/10',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: HueColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: HueSpacing.sm),
                Expanded(
                  child: state.templates.isEmpty
                      ? Center(
                          child: Text(
                            'Bu kategoride şablon yok.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: HueColors.textSecondary),
                          ),
                        )
                      : ListView.separated(
                          itemCount: state.templates.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: HueSpacing.xs),
                          itemBuilder: (context, index) {
                            final template = state.templates[index];
                            return _TemplateTile(
                              template: template,
                              onEdit: template.isDefault
                                  ? null
                                  : () => _onEditTemplate(
                                      context: context,
                                      controller: controller,
                                      template: template,
                                    ),
                              onDelete: template.isDefault
                                  ? null
                                  : () => _onDeleteTemplate(
                                      context: context,
                                      controller: controller,
                                      template: template,
                                    ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: HueSpacing.sm),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _onAddTemplate(context: context, controller: controller);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: HueSpacing.md,
                      vertical: HueSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: HueColors.blue,
                      borderRadius: BorderRadius.circular(HueRadius.lg),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.add, color: Colors.white),
                        SizedBox(width: HueSpacing.xs),
                        Text(
                          'Şablon Ekle',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onAddTemplate({
    required BuildContext context,
    required TemplatesController controller,
  }) async {
    if (!controller.canAddInSelectedCategory()) {
      await _showErrorDialog(
        context: context,
        message: 'Bu kategoride en fazla 10 özel şablon olabilir.',
      );
      return;
    }

    final text = await _showTemplateInputDialog(
      context: context,
      title: 'Yeni Şablon',
      actionLabel: 'Ekle',
    );
    if (text == null) return;

    final error = controller.addTemplate(text);
    if (error != null && context.mounted) {
      await _showErrorDialog(context: context, message: error);
    }
  }

  Future<void> _onEditTemplate({
    required BuildContext context,
    required TemplatesController controller,
    required Template template,
  }) async {
    final text = await _showTemplateInputDialog(
      context: context,
      title: 'Şablonu Düzenle',
      actionLabel: 'Kaydet',
      initialValue: template.text,
    );
    if (text == null) return;

    final error = controller.updateTemplate(
      templateId: template.id,
      text: text,
    );
    if (error != null && context.mounted) {
      await _showErrorDialog(context: context, message: error);
    }
  }

  Future<void> _onDeleteTemplate({
    required BuildContext context,
    required TemplatesController controller,
    required Template template,
  }) async {
    final confirmed = await _showDeleteConfirmDialog(context: context);
    if (!confirmed) return;

    final error = controller.deleteTemplate(template.id);
    if (error != null && context.mounted) {
      await _showErrorDialog(context: context, message: error);
    }
  }

  Future<String?> _showTemplateInputDialog({
    required BuildContext context,
    required String title,
    required String actionLabel,
    String? initialValue,
  }) async {
    final controller = TextEditingController(text: initialValue ?? '');
    final value = await showCupertinoDialog<String>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: HueSpacing.sm),
            child: CupertinoTextField(
              controller: controller,
              placeholder: 'Şablon metni',
              maxLines: 3,
              autofocus: true,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Vazgeç'),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(controller.text),
              child: Text(actionLabel),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return value;
  }

  Future<void> _showErrorDialog({
    required BuildContext context,
    required String message,
  }) async {
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Kaydedilemedi'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmDialog({required BuildContext context}) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Şablon silinsin mi?'),
          content: const Text('Bu işlem geri alınamaz.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({required this.template, this.onEdit, this.onDelete});

  final Template template;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HueSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(HueRadius.md),
        border: Border.all(
          color: template.category.color.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: HueSpacing.xxs),
                Text(
                  template.isDefault ? 'Varsayılan' : 'Özel',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: HueColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null) ...[
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: HueSpacing.xs),
              minimumSize: const Size(32, 32),
              onPressed: onEdit,
              child: const Icon(CupertinoIcons.pencil, size: 18),
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: HueSpacing.xs),
              minimumSize: const Size(32, 32),
              onPressed: onDelete,
              child: const Icon(
                CupertinoIcons.delete,
                size: 18,
                color: Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
