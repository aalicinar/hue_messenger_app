import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/models/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.isHighlighted = false,
  });

  final Message message;
  final bool isMe;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
        : Theme.of(context).colorScheme.surface;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: HueSpacing.xxs),
          padding: const EdgeInsets.all(HueSpacing.sm),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(HueRadius.md),
            border: isHighlighted
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message.text ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: HueSpacing.xxs),
              Text(
                DateFormat('HH:mm').format(message.createdAt),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: HueColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
