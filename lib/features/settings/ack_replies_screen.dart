import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
import '../../app/theme/tokens.dart';
import '../../shared/widgets/hue_backdrop.dart';
import 'ack_replies_controller.dart';

class AckRepliesScreen extends ConsumerWidget {
  const AckRepliesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replies = ref.watch(ackRepliesControllerProvider);
    final controller = ref.read(ackRepliesControllerProvider.notifier);
    final lang = ref.watch(localeProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.get(lang, 'ack_replies_nav_title')),
      ),
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
                      Text(
                        S.get(lang, 'ack_replies_description'),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: HueSpacing.xxs),
                      Text(
                        S.get(lang, 'ack_replies_count').replaceAll(
                          '{n}',
                          '${replies.length}',
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: HueColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: HueSpacing.sm),
                Expanded(
                  child: replies.isEmpty
                      ? Center(
                          child: Text(
                            S.get(lang, 'ack_replies_empty'),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: HueColors.textSecondary),
                          ),
                        )
                      : ListView.separated(
                          itemCount: replies.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: HueSpacing.xs),
                          itemBuilder: (context, index) {
                            final reply = replies[index];
                            return _ReplyTile(
                              reply: reply,
                              onEdit: () => _onEditReply(
                                context: context,
                                controller: controller,
                                index: index,
                                initialValue: reply,
                                lang: lang,
                              ),
                              onDelete: () => _onDeleteReply(
                                context: context,
                                controller: controller,
                                index: index,
                                lang: lang,
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
                    _onAddReply(
                      context: context,
                      controller: controller,
                      currentCount: replies.length,
                      lang: lang,
                    );
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.add, color: Colors.white),
                        const SizedBox(width: HueSpacing.xs),
                        Text(
                          S.get(lang, 'ack_replies_add_button'),
                          style: const TextStyle(
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

  Future<void> _onAddReply({
    required BuildContext context,
    required AckRepliesController controller,
    required int currentCount,
    required AppLanguage lang,
  }) async {
    if (currentCount >= 3) {
      await _showErrorDialog(
        context: context,
        message: S.get(lang, 'ack_replies_limit_error'),
        lang: lang,
      );
      return;
    }

    final value = await _showReplyInputDialog(
      context: context,
      title: S.get(lang, 'ack_replies_new_title'),
      actionLabel: S.get(lang, 'common_add'),
      lang: lang,
    );
    if (value == null) return;

    final error = controller.addReply(value);
    if (error != null && context.mounted) {
      await _showErrorDialog(context: context, message: error, lang: lang);
    }
  }

  Future<void> _onEditReply({
    required BuildContext context,
    required AckRepliesController controller,
    required int index,
    required String initialValue,
    required AppLanguage lang,
  }) async {
    final value = await _showReplyInputDialog(
      context: context,
      title: S.get(lang, 'ack_replies_edit_title'),
      actionLabel: S.get(lang, 'common_save'),
      initialValue: initialValue,
      lang: lang,
    );
    if (value == null) return;

    final error = controller.updateReplyAt(index: index, value: value);
    if (error != null && context.mounted) {
      await _showErrorDialog(context: context, message: error, lang: lang);
    }
  }

  Future<void> _onDeleteReply({
    required BuildContext context,
    required AckRepliesController controller,
    required int index,
    required AppLanguage lang,
  }) async {
    final confirmed = await _showDeleteConfirmDialog(context: context, lang: lang);
    if (!confirmed) return;

    final error = controller.removeReplyAt(index);
    if (error != null && context.mounted) {
      await _showErrorDialog(context: context, message: error, lang: lang);
    }
  }

  Future<String?> _showReplyInputDialog({
    required BuildContext context,
    required String title,
    required String actionLabel,
    required AppLanguage lang,
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
              placeholder: S.get(lang, 'ack_replies_input_placeholder'),
              maxLength: 24,
              autofocus: true,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(S.get(lang, 'cancel')),
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
    required AppLanguage lang,
  }) async {
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text(S.get(lang, 'common_could_not_save')),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(S.get(lang, 'common_ok')),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmDialog({
    required BuildContext context,
    required AppLanguage lang,
  }) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text(S.get(lang, 'ack_replies_delete_title')),
          content: Text(S.get(lang, 'ack_replies_delete_body')),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(S.get(lang, 'cancel')),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(S.get(lang, 'common_delete')),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }
}

class _ReplyTile extends StatelessWidget {
  const _ReplyTile({
    required this.reply,
    required this.onEdit,
    required this.onDelete,
  });

  final String reply;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HueSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(HueRadius.md),
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
            child: Text(reply, style: Theme.of(context).textTheme.titleMedium),
          ),
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
      ),
    );
  }
}
