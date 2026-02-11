import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme/tokens.dart';

class HueAvatar extends StatelessWidget {
  const HueAvatar({
    super.key,
    required this.name,
    this.size = 44,
    this.showBorder = true,
  });

  final String name;
  final double size;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = _gradientFor(name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        border: showBorder
            ? Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white,
                width: size > 40 ? 2.5 : 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          _initials(name),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.36,
            letterSpacing: -0.3,
            height: 1,
          ),
        ),
      ),
    ).animate().scale(
      begin: const Offset(0.85, 0.85),
      end: const Offset(1.0, 1.0),
      duration: 300.ms,
      curve: Curves.easeOutBack,
    );
  }

  static List<Color> _gradientFor(String name) {
    if (name.isEmpty) return HueColors.avatarGradients[0];
    final hash = name.codeUnits.fold<int>(0, (acc, c) => acc + c);
    return HueColors.avatarGradients[hash % HueColors.avatarGradients.length];
  }

  static String _initials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
}
