import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
import '../../app/theme/tokens.dart';
import '../../core/models/hue_category.dart';
import '../../shared/widgets/hue_backdrop.dart';
import '../../shared/widgets/hue_category_badge.dart';
import 'rate_limits_controller.dart';

class RateLimitsScreen extends ConsumerWidget {
  const RateLimitsScreen({super.key});

  static const List<int> _options = [
    0,
    60,
    300,
    900,
    1800,
    3600,
    7200,
    21600,
    43200,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limits = ref.watch(rateLimitsControllerProvider);
    final controller = ref.read(rateLimitsControllerProvider.notifier);
    final lang = ref.watch(localeProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.get(lang, 'rate_limits_nav_title')),
      ),
      child: HueBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(HueSpacing.md),
            children: [
              HueGlassCard(
                child: Text(S.get(lang, 'rate_limits_description')),
              ),
              const SizedBox(height: HueSpacing.sm),
              for (final category in HueCategory.values) ...[
                _RateLimitTile(
                  category: category,
                  title: _categoryLabel(lang, category),
                  valueLabel: _formatSeconds(
                    limits.secondsFor(category),
                    lang: lang,
                  ),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _showOptions(
                      context: context,
                      category: category,
                      selected: limits.secondsFor(category),
                      lang: lang,
                      onSelected: (seconds) => controller.updateCategory(
                        category: category,
                        seconds: seconds,
                      ),
                    );
                  },
                ),
                const SizedBox(height: HueSpacing.xs),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showOptions({
    required BuildContext context,
    required HueCategory category,
    required int selected,
    required AppLanguage lang,
    required ValueChanged<int> onSelected,
  }) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: Text(S.get(lang, 'rate_limits_sheet_title')),
          actions: [
            for (final seconds in _options)
              CupertinoActionSheetAction(
                isDefaultAction: seconds == selected,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  onSelected(seconds);
                },
                child: Text(_formatSeconds(seconds, lang: lang)),
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

  static String _categoryLabel(AppLanguage lang, HueCategory category) {
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

  static String _formatSeconds(int seconds, {required AppLanguage lang}) {
    final sec = S.get(lang, 'rate_limits_unit_sec');
    final min = S.get(lang, 'rate_limits_unit_min');
    final hour = S.get(lang, 'rate_limits_unit_hour');

    if (seconds <= 0) return S.get(lang, 'rate_limits_unlimited');
    if (seconds < 60) return '$seconds $sec';
    if (seconds % 3600 == 0) {
      final hours = seconds ~/ 3600;
      return '$hours $hour';
    }
    if (seconds % 60 == 0) {
      final minutes = seconds ~/ 60;
      return '$minutes $min';
    }
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '$minutes $min $remainder $sec';
  }
}

class _RateLimitTile extends StatelessWidget {
  const _RateLimitTile({
    required this.category,
    required this.title,
    required this.valueLabel,
    required this.onTap,
  });

  final HueCategory category;
  final String title;
  final String valueLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(HueSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(HueRadius.md),
          border: Border.all(color: category.color.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            HueCategoryBadge(category: category, size: 24),
            const SizedBox(width: HueSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              valueLabel,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: HueColors.textSecondary),
            ),
            const SizedBox(width: HueSpacing.xs),
            const Icon(CupertinoIcons.chevron_right, size: 16),
          ],
        ),
      ),
    );
  }
}
