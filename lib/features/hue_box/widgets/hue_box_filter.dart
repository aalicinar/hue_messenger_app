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
    this.allLabel = 'All',
  });

  final HueBoxFilter selectedFilter;
  final ValueChanged<HueBoxFilter> onChanged;
  final String allLabel;

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
              allLabel: allLabel,
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
    required this.allLabel,
  });

  final HueBoxFilter filter;
  final bool isSelected;
  final VoidCallback onTap;
  final String allLabel;

  @override
  Widget build(BuildContext context) {
    final isAll = filter == HueBoxFilter.all;
    final color = isAll ? const Color(0xFF6366F1) : filter.category!.color;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(72, 38),
      onPressed: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: HueSpacing.sm + 2,
          vertical: HueSpacing.xs,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: isAll
                      ? [color, color.withValues(alpha: 0.85)]
                      : [
                          color.withValues(alpha: 0.25),
                          color.withValues(alpha: 0.12),
                        ],
                )
              : null,
          color: isSelected ? null : color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(HueRadius.pill),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: isAll ? 1.0 : 0.6)
                : color.withValues(alpha: 0.15),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? HueShadows.glowFor(color, intensity: 0.15)
              : null,
        ),
        child: isAll
            ? Text(
                filter == HueBoxFilter.all ? allLabel : filter.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HueCategoryBadge(
                    category: filter.category!,
                    size: 22,
                    isSelected: isSelected,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    Text(
                      filter.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
