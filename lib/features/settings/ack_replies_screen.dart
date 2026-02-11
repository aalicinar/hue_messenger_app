import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../shared/widgets/hue_backdrop.dart';
import 'ack_replies_controller.dart';

class AckRepliesScreen extends ConsumerWidget {
  const AckRepliesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replies = ref.watch(ackRepliesControllerProvider);
    final controller = ref.read(ackRepliesControllerProvider.notifier);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Onay Yanıtları'),
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
                        'H mesajı onaylarken kullanılan hızlı yanıtlar.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: HueSpacing.xxs),
                      Text(
                        '${replies.length}/3 seçenek',
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
                            'Henüz yanıt seçeneği yok.',
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
                              ),
                              onDelete: () => _onDeleteReply(
                                context: context,
                                controller: controller,
                                index: index,
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.add, color: Colors.white),
                        SizedBox(width: HueSpacing.xs),
                        Text(
                          'Yanıt Seçeneği Ekle',
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

  Future<void> _onAddReply({
    required BuildContext context,
    required AckRepliesController controller,
    required int currentCount,
  }) async {
    if (currentCount >= 3) {
      await _showErrorDialog(
        context: context,
        message: 'En fazla 3 yanıt seçeneği tanımlayabilirsin.',
      );
      return;
    }

    final value = await _showReplyInputDialog(
      context: context,
      title: 'Yeni Yanıt Seçeneği',
      actionLabel: 'Ekle',
    );
    if (value == null) return;

    final error = controller.addReply(value);
    if (error != null && context.mounted) {
      await _showErrorDialog(context: context, message: error);
    }
  }

  Future<void> _onEditReply({
    required BuildContext context,
    required AckRepliesController controller,
    required int index,
    required String initialValue,
  }) async {
    final value = await _showReplyInputDialog(
      context: context,
      title: 'Yanıt Seçeneğini Düzenle',
      actionLabel: 'Kaydet',
      initialValue: initialValue,
    );
    if (value == null) return;

    final error = controller.updateReplyAt(index: index, value: value);
    if (error != null && context.mounted) {
      await _showErrorDialog(context: context, message: error);
    }
  }

  Future<void> _onDeleteReply({
    required BuildContext context,
    required AckRepliesController controller,
    required int index,
  }) async {
    final confirmed = await _showDeleteConfirmDialog(context: context);
    if (!confirmed) return;

    final error = controller.removeReplyAt(index);
    if (error != null && context.mounted) {
      await _showErrorDialog(context: context, message: error);
    }
  }

  Future<String?> _showReplyInputDialog({
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
              placeholder: 'Yanıt metni',
              maxLength: 24,
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
          title: const Text('Yanıt seçeneği silinsin mi?'),
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
