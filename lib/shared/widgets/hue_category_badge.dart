import 'package:flutter/material.dart';

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
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.95)
              : Colors.transparent,
          width: isSelected ? 2.2 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isSelected ? 0.45 : 0.25),
            blurRadius: isSelected ? 14 : 8,
            spreadRadius: isSelected ? 1 : 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.22),
          child: Image.asset(
            category.iconAsset,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
