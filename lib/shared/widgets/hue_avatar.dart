import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme/tokens.dart';

class HueAvatar extends StatelessWidget {
  const HueAvatar({
    super.key,
    required this.name,
    this.size = 44,
    this.showBorder = true,
    this.avatarUrl,
  });

  final String name;
  final double size;
  final bool showBorder;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = _gradientFor(name);
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;
    final initials = _initials(name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasAvatar
            ? (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.04))
            : null,
        gradient: hasAvatar
            ? null
            : LinearGradient(
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
      child: ClipOval(
        child: hasAvatar
            ? _AvatarImage(source: avatarUrl!, initials: initials, size: size)
            : Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: size * 0.36,
                    letterSpacing: -0.3,
                    height: 1,
                  ),
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

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({
    required this.source,
    required this.initials,
    required this.size,
  });

  final String source;
  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: Colors.black.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.36,
          letterSpacing: -0.3,
          height: 1,
        ),
      ),
    );

    if (source.startsWith('preset:')) {
      return _PresetAvatarArt(preset: source.substring('preset:'.length));
    }

    if (source.startsWith('assets/')) {
      return Image.asset(
        source,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    return Image.network(
      source,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}

class _PresetAvatarArt extends StatelessWidget {
  const _PresetAvatarArt({required this.preset});

  final String preset;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(preset);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.background,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: const Alignment(-0.65, -0.5),
            child: _dot(style.primary, 0.52),
          ),
          Align(
            alignment: const Alignment(0.7, -0.45),
            child: _dot(style.secondary, 0.44),
          ),
          Align(
            alignment: const Alignment(0.58, 0.62),
            child: _dot(style.tertiary, 0.5),
          ),
          Align(
            alignment: const Alignment(-0.4, 0.72),
            child: _dot(Colors.white.withValues(alpha: 0.28), 0.34),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color, double scale) {
    return FractionallySizedBox(
      widthFactor: scale,
      heightFactor: scale,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.95),
              color.withValues(alpha: 0.55),
              color.withValues(alpha: 0.15),
            ],
          ),
        ),
      ),
    );
  }

  _AvatarPresetStyle _styleFor(String key) {
    switch (key) {
      case 'ember':
        return const _AvatarPresetStyle(
          background: [Color(0xFF2B0F0F), Color(0xFF5A1D1D)],
          primary: Color(0xFFEF4444),
          secondary: Color(0xFFF97316),
          tertiary: Color(0xFFF59E0B),
        );
      case 'amber':
        return const _AvatarPresetStyle(
          background: [Color(0xFF2A1B05), Color(0xFF5A3A0F)],
          primary: Color(0xFFF59E0B),
          secondary: Color(0xFFFACC15),
          tertiary: Color(0xFFF97316),
        );
      case 'mint':
        return const _AvatarPresetStyle(
          background: [Color(0xFF0C2B1E), Color(0xFF14532D)],
          primary: Color(0xFF10B981),
          secondary: Color(0xFF22C55E),
          tertiary: Color(0xFF34D399),
        );
      case 'sky':
        return const _AvatarPresetStyle(
          background: [Color(0xFF0A2242), Color(0xFF1E3A8A)],
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF06B6D4),
          tertiary: Color(0xFF60A5FA),
        );
      case 'spectrum':
      default:
        return const _AvatarPresetStyle(
          background: [Color(0xFF111827), Color(0xFF312E81)],
          primary: Color(0xFFEF4444),
          secondary: Color(0xFFF59E0B),
          tertiary: Color(0xFF10B981),
        );
    }
  }
}

class _AvatarPresetStyle {
  const _AvatarPresetStyle({
    required this.background,
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  final List<Color> background;
  final Color primary;
  final Color secondary;
  final Color tertiary;
}
