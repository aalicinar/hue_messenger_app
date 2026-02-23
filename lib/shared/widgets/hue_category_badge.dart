import 'package:flutter/material.dart';

import '../../core/models/hue_category.dart';

/// Clean, iOS-style category badge — smooth gradient square with glass depth.
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
    final radius = BorderRadius.circular(size * 0.28);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.black, 0.25)!],
        ),
        border: Border.all(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.15),
          width: isSelected ? 2 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isSelected ? 0.5 : 0.25),
            blurRadius: isSelected ? 12 : 6,
            spreadRadius: isSelected ? 1 : 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Stack(
          children: [
            // Top-left glass shine
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size * 0.45,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
