import 'dart:ui';
import 'package:flutter/material.dart';

import '../../app/theme/hue_theme.dart';
import '../../app/theme/theme_preset.dart';
import '../../app/theme/tokens.dart';

class HueBackdrop extends StatelessWidget {
  const HueBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final preset =
        Theme.of(context).extension<HueVisualSpec>()?.preset ??
        HueThemePreset.glassy;
    final colors = _backgroundFor(preset, brightness);

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ),
        // Subtle radial overlay for mesh effect
        if (preset == HueThemePreset.glassy)
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: brightness == Brightness.dark
                      ? [
                          const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                          Colors.transparent,
                        ]
                      : [
                          const Color(0xFF8B5CF6).withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
        if (preset == HueThemePreset.glassy)
          Positioned(
            bottom: -40,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: brightness == Brightness.dark
                      ? [
                          const Color(0xFF06B6D4).withValues(alpha: 0.06),
                          Colors.transparent,
                        ]
                      : [
                          const Color(0xFF3B82F6).withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                ),
              ),
            ),
          ),
        Positioned.fill(child: child),
      ],
    );
  }

  List<Color> _backgroundFor(HueThemePreset preset, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    if (preset == HueThemePreset.minimal) {
      return isDark
          ? const [Color(0xFF0C0F14), Color(0xFF111520), Color(0xFF141824)]
          : const [Color(0xFFFAFAFC), Color(0xFFF6F7FB), Color(0xFFF3F4F8)];
    }
    if (preset == HueThemePreset.highContrast) {
      return isDark
          ? const [Color(0xFF070A0F), Color(0xFF0B0F17), Color(0xFF0F1520)]
          : const [Color(0xFFEEF3FF), Color(0xFFE8EEFF), Color(0xFFF4F7FF)];
    }
    return isDark
        ? const [Color(0xFF0A0D14), Color(0xFF101625), Color(0xFF161D30)]
        : const [Color(0xFFF5F3FF), Color(0xFFF0F4FF), Color(0xFFFFF8F0)];
  }
}

class HueGlassCard extends StatelessWidget {
  const HueGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(HueSpacing.md),
    this.borderRadius,
    this.blurAmount = 24.0,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final double blurAmount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final preset =
        Theme.of(context).extension<HueVisualSpec>()?.preset ??
        HueThemePreset.glassy;

    final radius = borderRadius ?? BorderRadius.circular(HueRadius.lg);
    final cardColor = _cardColorFor(preset, isDark);
    final borderColor = _borderColorFor(preset, isDark);
    final shadows = isDark ? HueShadows.cardDark : HueShadows.cardLight;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 1),
            boxShadow: shadows,
          ),
          child: child,
        ),
      ),
    );
  }

  Color _cardColorFor(HueThemePreset preset, bool isDark) {
    switch (preset) {
      case HueThemePreset.minimal:
        return isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.88);
      case HueThemePreset.glassy:
        return isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.white.withValues(alpha: 0.68);
      case HueThemePreset.highContrast:
        return isDark
            ? const Color(0xFF141925)
            : Colors.white.withValues(alpha: 0.95);
    }
  }

  Color _borderColorFor(HueThemePreset preset, bool isDark) {
    switch (preset) {
      case HueThemePreset.minimal:
        return isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.9);
      case HueThemePreset.glassy:
        return isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.78);
      case HueThemePreset.highContrast:
        return isDark ? const Color(0xFF2A3344) : const Color(0xFFD8E0EF);
    }
  }
}
