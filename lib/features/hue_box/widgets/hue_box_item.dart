import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/models/hue_category.dart';
import '../../../core/models/message.dart';
import '../../../shared/widgets/hue_avatar.dart';
import '../../../shared/widgets/hue_backdrop.dart';
import '../../../shared/widgets/hue_category_badge.dart';

class HueBoxItem extends StatelessWidget {
  const HueBoxItem({
    super.key,
    required this.message,
    required this.senderName,
    this.senderAvatarUrl,
    required this.onTap,
    required this.onAcknowledge,
    required this.onAcknowledgeSwipe,
    required this.onLongPress,
    this.replyLabel = 'Reply',
    this.quickAckLabel = 'Quick acknowledge',
  });

  final Message message;
  final String senderName;
  final String? senderAvatarUrl;
  final VoidCallback onTap;
  final VoidCallback onAcknowledge;
  final VoidCallback onAcknowledgeSwipe;
  final VoidCallback? onLongPress;
  final String replyLabel;
  final String quickAckLabel;

  @override
  Widget build(BuildContext context) {
    final isUnacked = message.isUnacked;
    final categoryColor = message.category!.color;

    return Dismissible(
      key: Key('hue_box_item_${message.id}'),
      direction: isUnacked
          ? DismissDirection.endToStart
          : DismissDirection.none,
      confirmDismiss: (_) async {
        onAcknowledgeSwipe();
        return false;
      },
      background: _AckSwipeBackground(
        color: categoryColor,
        label: quickAckLabel,
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: HueGlassCard(
          padding: const EdgeInsets.all(HueSpacing.sm + 2),
          child: Row(
            children: [
              Stack(
                children: [
                  HueAvatar(
                    name: senderName,
                    size: 46,
                    avatarUrl: senderAvatarUrl,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: HueCategoryBadge(
                      category: message.category!,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: HueSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      senderName,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      message.templateText ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: HueColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: HueSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('HH:mm').format(message.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: HueColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: HueSpacing.xs),
                  if (isUnacked)
                    CupertinoButton(
                      minimumSize: const Size(34, 30),
                      padding: const EdgeInsets.symmetric(
                        horizontal: HueSpacing.sm,
                        vertical: 4,
                      ),
                      color: categoryColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(HueRadius.pill),
                      onPressed: onAcknowledge,
                      child: Text(
                        replyLabel,
                        style: TextStyle(
                          color: categoryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    )
                  else
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          size: 16,
                          color: HueColors.green,
                        ),
                        if (message.acknowledgedText != null &&
                            message.acknowledgedText!.isNotEmpty) ...[
                          const SizedBox(width: HueSpacing.xxs),
                          Text(
                            message.acknowledgedText!,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: HueColors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ],
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

class _AckSwipeBackground extends StatelessWidget {
  const _AckSwipeBackground({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: HueSpacing.lg),
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.05),
            color.withValues(alpha: 0.18),
          ],
        ),
        borderRadius: BorderRadius.circular(HueRadius.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.check_mark_circled, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
