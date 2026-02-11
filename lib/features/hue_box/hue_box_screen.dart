import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../core/mock/mock_repo.dart';
import '../../shared/widgets/hue_logo.dart';
import '../../shared/widgets/hue_backdrop.dart';
import '../chat_detail/chat_detail_screen.dart';
import 'hue_box_controller.dart';
import 'widgets/hue_box_empty_state.dart';
import 'widgets/hue_box_filter.dart';
import 'widgets/hue_box_item.dart';

class HueBoxScreen extends ConsumerWidget {
  const HueBoxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hueBoxControllerProvider);
    final controller = ref.read(hueBoxControllerProvider.notifier);
    final unackedCount = state.hueMessages
        .where((message) => message.isUnacked)
        .length;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Hue Box')),
      child: HueBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(HueSpacing.md),
            child: Column(
              children: [
                HueGlassCard(
                  child: Row(
                    children: [
                      const HueLogo(size: 44),
                      const SizedBox(width: HueSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sakin Kutu',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .navTitleTextStyle
                                  .copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: HueSpacing.xxs),
                            Text(
                              '$unackedCount bekleyen onay',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(color: HueColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: HueSpacing.md),
                Expanded(
                  child: state.filteredMessages.isEmpty
                      ? HueBoxEmptyState(filter: state.selectedFilter)
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: HueSpacing.sm),
                          itemCount: state.filteredMessages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: HueSpacing.xs),
                          itemBuilder: (context, index) {
                            final message = state.filteredMessages[index];
                            return HueBoxItem(
                              message: message,
                              senderName: _senderName(ref, message.senderId),
                              onTap: () => _openChatDetail(
                                context: context,
                                chatId: message.chatId,
                                messageId: message.id,
                              ),
                              onAcknowledge: () => _showReplyPicker(
                                context: context,
                                replyOptions: state.ackReplies,
                                onSelected: (reply) {
                                  HapticFeedback.mediumImpact();
                                  controller.acknowledge(
                                    message.id,
                                    replyText: reply,
                                  );
                                },
                              ),
                              onAcknowledgeSwipe: () {
                                HapticFeedback.mediumImpact();
                                controller.acknowledge(
                                  message.id,
                                  replyText: _defaultReply(state.ackReplies),
                                );
                              },
                              onLongPress: message.isUnacked
                                  ? () => _showReplyPicker(
                                      context: context,
                                      replyOptions: state.ackReplies,
                                      onSelected: (reply) {
                                        HapticFeedback.mediumImpact();
                                        controller.acknowledge(
                                          message.id,
                                          replyText: reply,
                                        );
                                      },
                                    )
                                  : null,
                            );
                          },
                        ),
                ),
                HueGlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: HueSpacing.sm,
                    vertical: HueSpacing.xs,
                  ),
                  child: HueBoxFilterControl(
                    selectedFilter: state.selectedFilter,
                    onChanged: (filter) {
                      HapticFeedback.selectionClick();
                      controller.setFilter(filter);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _senderName(WidgetRef ref, String senderId) {
    final repository = ref.read(mockRepositoryProvider);
    return repository.getUserById(senderId)?.name ?? 'Bilinmiyor';
  }

  Future<void> _openChatDetail({
    required BuildContext context,
    required String chatId,
    required String messageId,
  }) async {
    await Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (_) =>
            ChatDetailScreen(chatId: chatId, initialMessageId: messageId),
      ),
    );
  }

  Future<void> _showReplyPicker({
    required BuildContext context,
    required List<String> replyOptions,
    required ValueChanged<String> onSelected,
  }) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        final options = replyOptions.isEmpty
            ? const <String>['Tamam', 'Evet', 'Hayır']
            : replyOptions;
        return CupertinoActionSheet(
          title: const Text('Hızlı Yanıt'),
          message: const Text('Onay için bir yanıt seç.'),
          actions: [
            for (final reply in options)
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  onSelected(reply);
                },
                child: Text(reply),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            isDefaultAction: true,
            child: const Text('Vazgeç'),
          ),
        );
      },
    );
  }

  String _defaultReply(List<String> replies) {
    if (replies.isEmpty) return 'Tamam';
    return replies.first;
  }
}
