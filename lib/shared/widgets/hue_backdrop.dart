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

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: child,
    );
  }

  List<Color> _backgroundFor(HueThemePreset preset, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    if (preset == HueThemePreset.minimal) {
      return isDark
          ? const [Color(0xFF111317), Color(0xFF151821), Color(0xFF171B24)]
          : const [Color(0xFFF8F8FA), Color(0xFFF5F7FA), Color(0xFFF3F4F6)];
    }
    if (preset == HueThemePreset.highContrast) {
      return isDark
          ? const [Color(0xFF07090D), Color(0xFF0C1017), Color(0xFF111827)]
          : const [Color(0xFFEDF3FF), Color(0xFFE9F0FF), Color(0xFFF6FAFF)];
    }
    return isDark
        ? const [Color(0xFF111827), Color(0xFF1A1F30), Color(0xFF21293B)]
        : const [Color(0xFFF4F7FF), Color(0xFFF2FAFF), Color(0xFFFFF8EF)];
  }
}

class HueGlassCard extends StatelessWidget {
  const HueGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(HueSpacing.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final preset =
        Theme.of(context).extension<HueVisualSpec>()?.preset ??
        HueThemePreset.glassy;

    final cardColor = _cardColorFor(preset, isDark);
    final borderColor = _borderColorFor(preset, isDark);
    final shadows = _shadowsFor(preset, isDark);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(HueRadius.lg),
        border: Border.all(
          color: borderColor,
          width: preset == HueThemePreset.highContrast ? 1.4 : 1,
        ),
        boxShadow: shadows,
      ),
      child: child,
    );
  }

  Color _cardColorFor(HueThemePreset preset, bool isDark) {
    switch (preset) {
      case HueThemePreset.minimal:
        return isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9);
      case HueThemePreset.glassy:
        return isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.72);
      case HueThemePreset.highContrast:
        return isDark ? const Color(0xFF111827) : const Color(0xFFFFFFFF);
    }
  }

  Color _borderColorFor(HueThemePreset preset, bool isDark) {
    switch (preset) {
      case HueThemePreset.minimal:
        return isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.95);
      case HueThemePreset.glassy:
        return isDark
            ? Colors.white.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.88);
      case HueThemePreset.highContrast:
        return isDark ? const Color(0xFF2D3A4E) : const Color(0xFFD8E0EF);
    }
  }

  List<BoxShadow> _shadowsFor(HueThemePreset preset, bool isDark) {
    if (isDark) return const [];
    switch (preset) {
      case HueThemePreset.minimal:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ];
      case HueThemePreset.glassy:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ];
      case HueThemePreset.highContrast:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ];
    }
  }
}
