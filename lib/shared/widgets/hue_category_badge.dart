import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../../core/models/hue_category.dart';

class HueCategoryBadge extends StatelessWidget {
  const HueCategoryBadge({
    super.key,
    required this.category,
    this.size = 28,
    this.isSelected = false,
  });

  final HueCategory category;
  final double size;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = category.color;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(HueRadius.sm),
        border: Border.all(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.35),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isSelected ? 0.35 : 0.22),
            blurRadius: isSelected ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'H',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }
}
