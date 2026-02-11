import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
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
    final lang = ref.watch(localeProvider);
    final unackedCount = state.hueMessages
        .where((message) => message.isUnacked)
        .length;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.get(lang, 'hue_box_title')),
      ),
      child: HueBackdrop(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              HueSpacing.md,
              HueSpacing.md,
              HueSpacing.md,
              0,
            ),
            child: Column(
              children: [
                HueGlassCard(
                  child: Row(
                    children: [
                      const HueLogo(size: 42),
                      const SizedBox(width: HueSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.get(lang, 'hue_box_header'),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                if (unackedCount > 0) ...[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: HueColors.red,
                                      boxShadow: HueShadows.glowFor(
                                        HueColors.red,
                                        intensity: 0.4,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  S
                                      .get(lang, 'hue_box_pending')
                                      .replaceAll('{n}', '$unackedCount'),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: HueColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: HueSpacing.sm),
                HueGlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: HueSpacing.sm,
                    vertical: HueSpacing.xs,
                  ),
                  child: HueBoxFilterControl(
                    selectedFilter: state.selectedFilter,
                    allLabel: S.get(lang, 'filter_all'),
                    onChanged: (filter) {
                      HapticFeedback.selectionClick();
                      controller.setFilter(filter);
                    },
                  ),
                ),
                const SizedBox(height: HueSpacing.sm),
                Expanded(
                  child: state.filteredMessages.isEmpty
                      ? HueBoxEmptyState(
                          filter: state.selectedFilter,
                          lang: lang,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(
                            bottom: HueSpacing.xxl + HueSpacing.xl,
                          ),
                          itemCount: state.filteredMessages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: HueSpacing.xs),
                          itemBuilder: (context, index) {
                            final message = state.filteredMessages[index];
                            return HueBoxItem(
                                  message: message,
                                  senderName: _senderName(
                                    ref,
                                    message.senderId,
                                  ),
                                  replyLabel: S.get(lang, 'hue_box_reply'),
                                  quickAckLabel: S.get(
                                    lang,
                                    'hue_box_quick_ack',
                                  ),
                                  onTap: () => _openChatDetail(
                                    context: context,
                                    chatId: message.chatId,
                                    messageId: message.id,
                                  ),
                                  onAcknowledge: () => _showReplyPicker(
                                    context: context,
                                    lang: lang,
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
                                      replyText: _defaultReply(
                                        state.ackReplies,
                                      ),
                                    );
                                  },
                                  onLongPress: message.isUnacked
                                      ? () => _showReplyPicker(
                                          context: context,
                                          lang: lang,
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
                                )
                                .animate()
                                .fadeIn(
                                  duration: 350.ms,
                                  delay: (60 * index).ms,
                                )
                                .slideX(
                                  begin: 0.06,
                                  end: 0,
                                  duration: 350.ms,
                                  delay: (60 * index).ms,
                                  curve: Curves.easeOutCubic,
                                );
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
    return repository.getUserById(senderId)?.name ?? 'Unknown';
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
    required AppLanguage lang,
    required List<String> replyOptions,
    required ValueChanged<String> onSelected,
  }) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        final options = replyOptions.isEmpty
            ? const <String>['OK', 'Yes', 'No']
            : replyOptions;
        return CupertinoActionSheet(
          title: Text(S.get(lang, 'hue_box_reply_title')),
          message: Text(S.get(lang, 'hue_box_reply_message')),
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
            child: Text(S.get(lang, 'cancel')),
          ),
        );
      },
    );
  }

  String _defaultReply(List<String> replies) {
    if (replies.isEmpty) return 'OK';
    return replies.first;
  }
}
