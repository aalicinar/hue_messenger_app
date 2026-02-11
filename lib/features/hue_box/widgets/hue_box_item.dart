import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/models/hue_category.dart';
import '../../../core/models/message.dart';
import '../../../shared/widgets/hue_category_badge.dart';

class HueBoxItem extends StatelessWidget {
  const HueBoxItem({
    super.key,
    required this.message,
    required this.senderName,
    required this.onTap,
    required this.onAcknowledge,
    required this.onAcknowledgeSwipe,
    required this.onLongPress,
  });

  final Message message;
  final String senderName;
  final VoidCallback onTap;
  final VoidCallback onAcknowledge;
  final VoidCallback onAcknowledgeSwipe;
  final VoidCallback? onLongPress;

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
      background: _AckSwipeBackground(color: categoryColor),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.all(HueSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(HueRadius.md),
            border: Border(left: BorderSide(color: categoryColor, width: 4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: categoryColor.withValues(alpha: 0.18),
                child: Text(
                  senderName.characters.first.toUpperCase(),
                  style: TextStyle(
                    color: categoryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: HueSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          senderName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: HueSpacing.xs),
                        HueCategoryBadge(category: message.category!, size: 22),
                      ],
                    ),
                    const SizedBox(height: HueSpacing.xxs),
                    Text(
                      message.templateText ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: HueSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('HH:mm').format(message.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: HueSpacing.xxs),
                  if (isUnacked)
                    CupertinoButton(
                      minimumSize: const Size(34, 34),
                      padding: const EdgeInsets.symmetric(
                        horizontal: HueSpacing.sm,
                      ),
                      color: categoryColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(HueRadius.pill),
                      onPressed: onAcknowledge,
                      child: Text(
                        'Yanıtla',
                        style: TextStyle(
                          color: categoryColor,
                          fontWeight: FontWeight.w700,
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
                          color: Colors.green.shade500,
                        ),
                        if (message.acknowledgedText != null &&
                            message.acknowledgedText!.isNotEmpty) ...[
                          const SizedBox(width: HueSpacing.xxs),
                          Text(
                            message.acknowledgedText!,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Colors.green.shade700,
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
  const _AckSwipeBackground({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: HueSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(HueRadius.md),
      ),
      child: Text(
        'Hızlı onay',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
