import 'package:flutter/material.dart';

class HueColors {
  const HueColors._();

  // ── Core neutrals ──
  static const neutralBackground = Color(0xFFF7F8FA);
  static const neutralCard = Color(0xFFFFFFFF);
  static const neutralBackgroundDark = Color(0xFF0C0F14);
  static const neutralCardDark = Color(0xFF161B24);
  static const textPrimary = Color(0xFF0F1117);
  static const textSecondary = Color(0xFF6B7280);
  static const separator = Color(0xFFE2E5EB);

  // ── Category solids ──
  static const red = Color(0xFFEF4444);
  static const yellow = Color(0xFFF59E0B);
  static const green = Color(0xFF10B981);
  static const blue = Color(0xFF3B82F6);

  // ── Category soft tints ──
  static const redTint = Color(0xFFFEF2F2);
  static const yellowTint = Color(0xFFFFFBEB);
  static const greenTint = Color(0xFFECFDF5);
  static const blueTint = Color(0xFFEFF6FF);

  // ── Accent gradients ──
  static const List<Color> accentGradient = [
    Color(0xFF6366F1), // indigo
    Color(0xFF8B5CF6), // violet
    Color(0xFFA855F7), // purple
  ];

  static const List<Color> warmGradient = [
    Color(0xFFF97316), // orange
    Color(0xFFF43F5E), // rose
    Color(0xFFEC4899), // pink
  ];

  static const List<Color> coolGradient = [
    Color(0xFF06B6D4), // cyan
    Color(0xFF3B82F6), // blue
    Color(0xFF8B5CF6), // violet
  ];

  // ── Avatar palette (deterministic by name hash) ──
  static const List<List<Color>> avatarGradients = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    [Color(0xFFF43F5E), Color(0xFFFB923C)],
    [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    [Color(0xFF10B981), Color(0xFF34D399)],
    [Color(0xFFF59E0B), Color(0xFFF97316)],
    [Color(0xFFEC4899), Color(0xFFA855F7)],
    [Color(0xFF14B8A6), Color(0xFF06B6D4)],
    [Color(0xFF8B5CF6), Color(0xFFEC4899)],
  ];
}

class HueSpacing {
  const HueSpacing._();

  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

class HueRadius {
  const HueRadius._();

  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 20.0;
  static const xl = 28.0;
  static const pill = 999.0;
}

class HueShadows {
  const HueShadows._();

  static List<BoxShadow> cardLight = [
    BoxShadow(
      color: const Color(0xFF6366F1).withValues(alpha: 0.06),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> cardDark = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> glowFor(Color color, {double intensity = 0.25}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity),
        blurRadius: 16,
        spreadRadius: 1,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
