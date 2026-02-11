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
    this.hueLabel = 'H Message',
    this.replyLabel = 'Reply',
  });

  final Message message;
  final bool isMe;
  final VoidCallback onAcknowledge;
  final bool isHighlighted;
  final String hueLabel;
  final String replyLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = message.category!;
    final color = category.color;
    final acknowledgedText = message.acknowledgedText?.trim();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(HueSpacing.sm),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(HueRadius.lg),
            border: Border.all(
              color: isHighlighted
                  ? const Color(0xFF6366F1)
                  : color.withValues(alpha: isDark ? 0.5 : 0.35),
              width: isHighlighted ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: isDark ? 0.15 : 0.12),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // ── Hue label ──
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: HueSpacing.xs,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(HueRadius.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HueCategoryBadge(category: category, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      hueLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: HueSpacing.xs),
              Text(
                message.templateText ?? '',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: HueSpacing.xs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('HH:mm').format(message.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: HueColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(width: HueSpacing.xs),
                  if (!isMe && message.isUnacked)
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: HueSpacing.sm,
                        vertical: 4,
                      ),
                      minimumSize: const Size(24, 26),
                      onPressed: onAcknowledge,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: HueSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(HueRadius.pill),
                          border: Border.all(
                            color: color.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          replyLabel,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
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
                          color: HueColors.green,
                        ),
                        const SizedBox(width: HueSpacing.xxs),
                        Text(
                          acknowledgedText,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: HueColors.green,
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
                          ? HueColors.textSecondary.withValues(alpha: 0.4)
                          : HueColors.green,
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
