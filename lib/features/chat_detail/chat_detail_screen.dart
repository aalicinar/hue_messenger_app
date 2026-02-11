import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
import '../../app/theme/tokens.dart';
import '../../core/mock/mock_repo.dart';
import '../../core/models/message.dart';
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

    _maybeScrollToInitial(state.messages);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HueAvatar(name: state.title, size: 28, showBorder: false),
            const SizedBox(width: HueSpacing.xs),
            Flexible(child: Text(state.title, overflow: TextOverflow.ellipsis)),
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
                          return KeyedSubtree(
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
    final options = replyOptions.isEmpty
        ? const <String>['OK', 'Yes', 'No']
        : replyOptions;
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: Text(S.get(lang, 'hue_box_reply_title')),
          message: Text(S.get(lang, 'hue_box_reply_message')),
          actions: [
            for (final option in options)
              CupertinoActionSheetAction(
                onPressed: () => Navigator.of(sheetContext).pop(option),
                child: Text(option),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            isDefaultAction: true,
            child: Text(S.get(lang, 'cancel')),
          ),
        );
      },
    );
  }

  Future<void> _showRateLimitBlockedDialog({
    required BuildContext context,
    required AppLanguage lang,
    required Duration retryAfter,
  }) async {
    final waitText = _formatWait(retryAfter);
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
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatWait(Duration duration) {
    if (duration <= Duration.zero) return 'a moment';
    if (duration.inSeconds < 60) return '${duration.inSeconds}s';
    if (duration.inMinutes < 60) {
      final seconds = duration.inSeconds % 60;
      if (seconds == 0) return '${duration.inMinutes}m';
      return '${duration.inMinutes}m ${seconds}s';
    }
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${hours}h ${minutes}m ${seconds}s';
  }
}
