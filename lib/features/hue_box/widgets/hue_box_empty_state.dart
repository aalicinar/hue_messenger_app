import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app/app_strings.dart';
import '../../../app/locale_provider.dart';
import '../../../app/theme/tokens.dart';
import '../hue_box_controller.dart';

class HueBoxEmptyState extends StatelessWidget {
  const HueBoxEmptyState({super.key, required this.filter, required this.lang});

  final HueBoxFilter filter;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final isAll = filter == HueBoxFilter.all;
    final message = isAll
        ? S.get(lang, 'hue_box_empty_all')
        : S.get(lang, 'hue_box_empty_filter');
    final icon = isAll
        ? CupertinoIcons.tray
        : CupertinoIcons.line_horizontal_3_decrease_circle;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: HueColors.textSecondary.withValues(alpha: 0.06),
            ),
            child: Icon(
              icon,
              size: 32,
              color: HueColors.textSecondary.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(height: HueSpacing.md),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: HueColors.textSecondary),
          ),
          if (isAll) ...[
            const SizedBox(height: HueSpacing.xs),
            Text(
              S.get(lang, 'hue_box_empty_hint'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: HueColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
