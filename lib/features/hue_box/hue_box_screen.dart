import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
import '../../app/theme/tokens.dart';
import '../../core/mock/mock_repo.dart';
import '../../core/models/user.dart';
import '../../shared/widgets/ack_reply_sheet.dart';
import '../../shared/widgets/hue_screen_header.dart';
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
        transitionBetweenRoutes: false,
        middle: Text(S.get(lang, 'hue_box_title')),
      ),
      child: HueBackdrop(
        child: Stack(
          children: [
            SafeArea(
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
                    HueScreenHeader(
                      title: S.get(lang, 'hue_box_header'),
                      subtitle: S
                          .get(lang, 'hue_box_pending')
                          .replaceAll('{n}', '$unackedCount'),
                      showDot: unackedCount > 0,
                      dotColor: HueColors.red,
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
                                final sender = _sender(ref, message.senderId);
                                return HueBoxItem(
                                      message: message,
                                      senderName:
                                          sender?.name ??
                                          S.get(lang, 'chats_unknown'),
                                      senderAvatarUrl: sender?.avatarUrl,
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
                                            lang,
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

            // ── FAB: New message ──
            Positioned(
              right: HueSpacing.md,
              bottom: HueSpacing.xxl + HueSpacing.lg,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _showNewMessageDialog(context, lang);
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: HueColors.accentGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  User? _sender(WidgetRef ref, String senderId) {
    final repository = ref.read(mockRepositoryProvider);
    return repository.getUserById(senderId);
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
    final selected = await showAckReplySheet(
      context: context,
      lang: lang,
      replyOptions: replyOptions,
      title: S.get(lang, 'hue_box_reply_title'),
      message: S.get(lang, 'hue_box_reply_message'),
      cancelLabel: S.get(lang, 'cancel'),
    );
    if (selected == null) return;
    onSelected(selected);
  }

  String _defaultReply(List<String> replies, AppLanguage lang) {
    if (replies.isEmpty) return S.get(lang, 'common_ok');
    return replies.first;
  }

  Future<void> _showNewMessageDialog(
    BuildContext context,
    AppLanguage lang,
  ) async {
    final repository = ProviderScope.containerOf(
      context,
    ).read(mockRepositoryProvider);
    final currentUser = repository.getCurrentUser();
    final contacts = repository
        .getUsers()
        .where((u) => u.id != currentUser.id)
        .toList();

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) {
        return CupertinoActionSheet(
          title: Text(S.get(lang, 'chats_new_title')),
          actions: [
            for (final contact in contacts)
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  final chat = repository.createOrGetChat(
                    currentUserId: currentUser.id,
                    otherUserId: contact.id,
                  );
                  _openChatDetail(
                    context: context,
                    chatId: chat.id,
                    messageId: '',
                  );
                },
                child: Text(contact.name),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(ctx).pop(),
            isDefaultAction: true,
            child: Text(S.get(lang, 'cancel')),
          ),
        );
      },
    );
  }
}
