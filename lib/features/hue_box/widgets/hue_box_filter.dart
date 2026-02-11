import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/models/hue_category.dart';
import '../../../shared/widgets/hue_category_badge.dart';
import '../hue_box_controller.dart';

class HueBoxFilterControl extends StatelessWidget {
  const HueBoxFilterControl({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final HueBoxFilter selectedFilter;
  final ValueChanged<HueBoxFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in HueBoxFilter.values) ...[
            _FilterChip(
              filter: filter,
              isSelected: selectedFilter == filter,
              onTap: () => onChanged(filter),
            ),
            if (filter != HueBoxFilter.values.last)
              const SizedBox(width: HueSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  final HueBoxFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isAll = filter == HueBoxFilter.all;
    final color = filter == HueBoxFilter.all
        ? Theme.of(context).colorScheme.primary
        : filter.category!.color;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(72, 38),
      onPressed: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: HueSpacing.sm,
          vertical: HueSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isAll
              ? (isSelected ? color : color.withValues(alpha: 0.12))
              : (isSelected
                    ? color.withValues(alpha: 0.18)
                    : color.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(HueRadius.pill),
          border: Border.all(
            color: isSelected
                ? color
                : color.withValues(alpha: isAll ? 0.35 : 0.26),
          ),
        ),
        child: isAll
            ? Text(
                filter.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.w700,
                ),
              )
            : HueCategoryBadge(
                category: filter.category!,
                size: 26,
                isSelected: isSelected,
              ),
      ),
    );
  }
}
