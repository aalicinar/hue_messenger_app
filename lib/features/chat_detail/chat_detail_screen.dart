import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
import '../../app/theme/tokens.dart';
import '../../core/mock/mock_repo.dart';
import '../../core/models/message.dart';
import '../../core/models/hue_category.dart';
import '../../shared/widgets/ack_reply_sheet.dart';
import '../../shared/widgets/hue_avatar.dart';
import '../../shared/widgets/hue_backdrop.dart';
import 'chat_detail_controller.dart';
import 'widgets/composer.dart';
import 'widgets/hue_bubble.dart';
import 'widgets/hue_sheet.dart';
import 'widgets/message_bubble.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.chatId,
    this.initialMessageId,
  });

  final String chatId;
  final String? initialMessageId;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final Map<String, GlobalKey> _messageKeys = <String, GlobalKey>{};
  bool _didInitialScroll = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatDetailControllerProvider(widget.chatId));
    final controller = ref.read(
      chatDetailControllerProvider(widget.chatId).notifier,
    );
    final repository = ref.read(mockRepositoryProvider);
    final lang = ref.watch(localeProvider);
    final recipient = state.recipientId.isEmpty
        ? null
        : repository.getUserById(state.recipientId);
    final displayTitle = state.title.trim().isEmpty
        ? S.get(lang, 'chats_unknown')
        : state.title;

    _maybeScrollToInitial(state.messages);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HueAvatar(
              name: displayTitle,
              size: 28,
              showBorder: false,
              avatarUrl: recipient?.avatarUrl,
            ),
            const SizedBox(width: HueSpacing.xs),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayTitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HueColors.green,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        S.get(lang, 'chat_online'),
                        style: TextStyle(
                          fontSize: 11,
                          color: HueColors.green,
                          fontWeight: FontWeight.w600,
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
      child: HueBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: state.messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.chat_bubble,
                              size: 40,
                              color: HueColors.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            const SizedBox(height: HueSpacing.sm),
                            Text(
                              S.get(lang, 'chat_empty'),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: HueColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(HueSpacing.md),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          final showDateSep = _shouldShowDateSeparator(
                            state.messages,
                            index,
                          );
                          return Column(
                            children: [
                              if (showDateSep)
                                _DateSeparator(
                                  date: message.createdAt,
                                  lang: lang,
                                ),
                              KeyedSubtree(
                                key: _keyForMessage(message.id),
                                child: _buildMessageTile(
                                  message: message,
                                  isMe:
                                      message.senderId ==
                                      MockRepository.currentUserId,
                                  isHighlighted:
                                      message.id == widget.initialMessageId,
                                  onAcknowledge: () => _onAcknowledgeHue(
                                    context: context,
                                    lang: lang,
                                    controller: controller,
                                    messageId: message.id,
                                    replyOptions: state.ackReplies,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              ChatComposer(
                placeholder: S.get(lang, 'chat_composer_placeholder'),
                onSend: (text) {
                  HapticFeedback.selectionClick();
                  controller.sendNormalMessage(text);
                },
                onOpenHue: () => _openHueSheet(
                  context: context,
                  lang: lang,
                  controller: controller,
                  repository: repository,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTile({
    required Message message,
    required bool isMe,
    required bool isHighlighted,
    required VoidCallback onAcknowledge,
  }) {
    if (message.type == MessageType.hue) {
      return HueBubble(
        message: message,
        isMe: isMe,
        isHighlighted: isHighlighted,
        onAcknowledge: onAcknowledge,
        hueLabel: S.get(ref.read(localeProvider), 'hue_label'),
        replyLabel: S.get(ref.read(localeProvider), 'hue_box_reply'),
      );
    }

    return MessageBubble(
      message: message,
      isMe: isMe,
      isHighlighted: isHighlighted,
    );
  }

  GlobalKey _keyForMessage(String messageId) {
    return _messageKeys.putIfAbsent(messageId, GlobalKey.new);
  }

  void _maybeScrollToInitial(List<Message> messages) {
    if (_didInitialScroll) return;

    final targetId = widget.initialMessageId;
    if (targetId == null) {
      _didInitialScroll = true;
      return;
    }

    if (!messages.any((message) => message.id == targetId)) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didInitialScroll) return;

      final targetContext = _messageKeys[targetId]?.currentContext;
      if (targetContext == null) return;

      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        alignment: 0.2,
      );
      _didInitialScroll = true;
    });
  }

  Future<void> _openHueSheet({
    required BuildContext context,
    required AppLanguage lang,
    required ChatDetailController controller,
    required MockRepository repository,
  }) async {
    final templates = repository.getTemplates();
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return HueSheet(
          templates: templates,
          title: S.get(lang, 'hue_sheet_title'),
          allLabel: S.get(lang, 'filter_all'),
          emptyLabel: S.get(lang, 'hue_sheet_empty'),
          categoryLabelBuilder: (category) => _categoryLabel(lang, category),
          onTemplateSelected: (template) async {
            Navigator.of(sheetContext).pop();
            HapticFeedback.selectionClick();
            final result = controller.sendHueMessage(template);
            if (!result.sent) {
              await _showRateLimitBlockedDialog(
                context: context,
                lang: lang,
                retryAfter: result.retryAfter,
              );
            }
          },
        );
      },
    );
  }

  String _categoryLabel(AppLanguage lang, HueCategory category) {
    switch (category) {
      case HueCategory.red:
        return S.get(lang, 'category_red');
      case HueCategory.yellow:
        return S.get(lang, 'category_yellow');
      case HueCategory.green:
        return S.get(lang, 'category_green');
      case HueCategory.blue:
        return S.get(lang, 'category_blue');
    }
  }

  Future<void> _onAcknowledgeHue({
    required BuildContext context,
    required AppLanguage lang,
    required ChatDetailController controller,
    required String messageId,
    required List<String> replyOptions,
  }) async {
    final selectedReply = await _showAckReplyPicker(
      context: context,
      lang: lang,
      replyOptions: replyOptions,
    );
    if (!mounted || selectedReply == null) return;

    HapticFeedback.mediumImpact();
    controller.acknowledgeHue(messageId, replyText: selectedReply);
  }

  Future<String?> _showAckReplyPicker({
    required BuildContext context,
    required AppLanguage lang,
    required List<String> replyOptions,
  }) async {
    return showAckReplySheet(
      context: context,
      lang: lang,
      replyOptions: replyOptions,
      title: S.get(lang, 'hue_box_reply_title'),
      message: S.get(lang, 'hue_box_reply_message'),
      cancelLabel: S.get(lang, 'cancel'),
    );
  }

  Future<void> _showRateLimitBlockedDialog({
    required BuildContext context,
    required AppLanguage lang,
    required Duration retryAfter,
  }) async {
    final waitText = _formatWait(retryAfter, lang: lang);
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text(S.get(lang, 'chat_rate_limit_title')),
          content: Text(
            S.get(lang, 'chat_rate_limit_body').replaceAll('{t}', waitText),
          ),
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

  String _formatWait(Duration duration, {required AppLanguage lang}) {
    final sec = S.get(lang, 'rate_limits_unit_sec');
    final min = S.get(lang, 'rate_limits_unit_min');
    final hour = S.get(lang, 'rate_limits_unit_hour');

    if (duration <= Duration.zero) return S.get(lang, 'chat_wait_moment');
    if (duration.inSeconds < 60) return '${duration.inSeconds} $sec';
    if (duration.inMinutes < 60) {
      final seconds = duration.inSeconds % 60;
      if (seconds == 0) return '${duration.inMinutes} $min';
      return '${duration.inMinutes} $min $seconds $sec';
    }
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '$hours $hour $minutes $min $seconds $sec';
  }

  bool _shouldShowDateSeparator(List<Message> messages, int index) {
    if (index == 0) return true;
    final prev = messages[index - 1].createdAt;
    final cur = messages[index].createdAt;
    return prev.year != cur.year ||
        prev.month != cur.month ||
        prev.day != cur.day;
  }
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date, required this.lang});

  final DateTime date;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final isYesterday =
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1;

    String label;
    if (isToday) {
      label = S.get(lang, 'chat_today');
    } else if (isYesterday) {
      label = S.get(lang, 'chat_yesterday');
    } else {
      label = DateFormat('d MMM yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: HueSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: HueColors.textSecondary.withValues(alpha: 0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HueSpacing.sm),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: HueColors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: HueColors.textSecondary.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}
