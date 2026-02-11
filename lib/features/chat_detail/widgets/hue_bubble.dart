import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/models/hue_category.dart';
import '../../../core/models/message.dart';
import '../../../shared/widgets/hue_category_badge.dart';

class HueBubble extends StatelessWidget {
  const HueBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.onAcknowledge,
    this.isHighlighted = false,
  });

  final Message message;
  final bool isMe;
  final VoidCallback onAcknowledge;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final category = message.category!;
    final acknowledgedText = message.acknowledgedText?.trim();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: HueSpacing.xxs),
          padding: const EdgeInsets.all(HueSpacing.sm),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(HueRadius.md),
            border: Border.all(
              color: isHighlighted
                  ? Theme.of(context).colorScheme.primary
                  : category.color,
              width: isHighlighted ? 4 : 3,
            ),
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HueCategoryBadge(category: category, size: 20),
                  const SizedBox(width: HueSpacing.xxs),
                  Text(
                    'H Mesajı',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: category.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: HueSpacing.xxs),
              Text(
                message.templateText ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: HueSpacing.xxs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('HH:mm').format(message.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: HueColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: HueSpacing.xs),
                  if (!isMe && message.isUnacked)
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: HueSpacing.xs,
                      ),
                      minimumSize: const Size(24, 24),
                      onPressed: onAcknowledge,
                      child: const Text('Yanıtla'),
                    )
                  else if (!isMe &&
                      acknowledgedText != null &&
                      acknowledgedText.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: HueSpacing.xxs),
                        Text(
                          acknowledgedText,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    )
                  else
                    Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      size: 14,
                      color: message.isUnacked
                          ? HueColors.textSecondary
                          : Colors.green,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
