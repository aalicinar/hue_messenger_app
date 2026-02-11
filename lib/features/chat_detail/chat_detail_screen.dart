import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/tokens.dart';
import '../../core/mock/mock_repo.dart';
import '../../core/models/message.dart';
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

    _maybeScrollToInitial(state.messages);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(state.title)),
      child: HueBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: state.messages.isEmpty
                    ? Center(
                        child: Text(
                          'Henüz mesaj yok.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: HueColors.textSecondary),
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
                onSend: (text) {
                  HapticFeedback.selectionClick();
                  controller.sendNormalMessage(text);
                },
                onOpenHue: () => _openHueSheet(
                  context: context,
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
    required ChatDetailController controller,
    required MockRepository repository,
  }) async {
    final templates = repository.getTemplates();
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return HueSheet(
          templates: templates,
          onTemplateSelected: (template) async {
            Navigator.of(sheetContext).pop();
            HapticFeedback.selectionClick();
            final result = controller.sendHueMessage(template);
            if (!result.sent) {
              await _showRateLimitBlockedDialog(
                context: context,
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
    required ChatDetailController controller,
    required String messageId,
    required List<String> replyOptions,
  }) async {
    final selectedReply = await _showAckReplyPicker(
      context: context,
      replyOptions: replyOptions,
    );
    if (!mounted || selectedReply == null) return;

    HapticFeedback.mediumImpact();
    controller.acknowledgeHue(messageId, replyText: selectedReply);
  }

  Future<String?> _showAckReplyPicker({
    required BuildContext context,
    required List<String> replyOptions,
  }) async {
    final options = replyOptions.isEmpty
        ? const <String>['Tamam', 'Evet', 'Hayır']
        : replyOptions;
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: const Text('Hızlı Yanıt'),
          message: const Text('Onay için bir yanıt seç.'),
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
            child: const Text('Vazgeç'),
          ),
        );
      },
    );
  }

  Future<void> _showRateLimitBlockedDialog({
    required BuildContext context,
    required Duration retryAfter,
  }) async {
    final waitText = _formatWait(retryAfter);
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Gönderim Sınırı Aktif'),
          content: Text(
            'Seçili H kategorisinde geçici sınır var. $waitText sonra tekrar dene.',
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
