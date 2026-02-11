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
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.white, 0.2) ?? color],
        ),
        border: Border.all(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.4),
          width: isSelected ? 2.2 : 1.2,
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
        child: Center(
          child: Text(
            'H',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              letterSpacing: -0.3,
              fontSize: size * 0.42,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
