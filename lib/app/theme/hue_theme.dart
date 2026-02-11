import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_preset.dart';
import 'tokens.dart';

class HueTheme {
  const HueTheme._();

  static TextTheme _buildTextTheme(Brightness brightness) {
    final base = GoogleFonts.interTextTheme(
      brightness == Brightness.light
          ? ThemeData.light().textTheme
          : ThemeData.dark().textTheme,
    );
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: 1.06,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.15,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.08,
      ),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.5, letterSpacing: -0.02),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.4, letterSpacing: -0.04),
      bodySmall: base.bodySmall?.copyWith(height: 1.33, letterSpacing: 0.02),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.02,
      ),
      labelMedium: base.labelMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  static ThemeData light({required HueThemePreset preset}) {
    final seed = _seedColorFor(preset);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      surface: const Color(0xFFFCFCFE),
      onSurface: HueColors.textPrimary,
    );
    final textTheme = _buildTextTheme(Brightness.light);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _scaffoldLightFor(preset),
      dividerColor: HueColors.separator,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: HueColors.textPrimary,
          fontSize: 17,
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: colorScheme.primary,
        barBackgroundColor: Colors.white.withValues(alpha: 0.72),
        textTheme: CupertinoTextThemeData(
          textStyle: textTheme.bodyMedium ?? const TextStyle(),
          navTitleTextStyle: textTheme.titleMedium?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          navLargeTitleTextStyle: textTheme.displaySmall?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[HueVisualSpec(preset: preset)],
    );
  }

  static ThemeData dark({required HueThemePreset preset}) {
    final seed = _seedColorFor(preset);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      surface: const Color(0xFF161B24),
      onSurface: Colors.white,
    );
    final textTheme = _buildTextTheme(Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _scaffoldDarkFor(preset),
      dividerColor: HueColors.separator.withValues(alpha: 0.18),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: colorScheme.primary,
        barBackgroundColor: const Color(0xFF0C0F14).withValues(alpha: 0.78),
        textTheme: CupertinoTextThemeData(
          textStyle: textTheme.bodyMedium ?? const TextStyle(),
          navTitleTextStyle: textTheme.titleMedium?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          navLargeTitleTextStyle: textTheme.displaySmall?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[HueVisualSpec(preset: preset)],
    );
  }

  static Color _seedColorFor(HueThemePreset preset) {
    switch (preset) {
      case HueThemePreset.minimal:
        return const Color(0xFF6366F1);
      case HueThemePreset.glassy:
        return const Color(0xFF8B5CF6);
      case HueThemePreset.highContrast:
        return const Color(0xFF3B82F6);
    }
  }

  static Color _scaffoldLightFor(HueThemePreset preset) {
    switch (preset) {
      case HueThemePreset.minimal:
        return const Color(0xFFF8F9FB);
      case HueThemePreset.glassy:
        return const Color(0xFFF5F3FF);
      case HueThemePreset.highContrast:
        return const Color(0xFFF0F4FF);
    }
  }

  static Color _scaffoldDarkFor(HueThemePreset preset) {
    switch (preset) {
      case HueThemePreset.minimal:
        return HueColors.neutralBackgroundDark;
      case HueThemePreset.glassy:
        return const Color(0xFF0A0D14);
      case HueThemePreset.highContrast:
        return const Color(0xFF070A0F);
    }
  }
}

class HueVisualSpec extends ThemeExtension<HueVisualSpec> {
  const HueVisualSpec({required this.preset});

  final HueThemePreset preset;

  @override
  HueVisualSpec copyWith({HueThemePreset? preset}) {
    return HueVisualSpec(preset: preset ?? this.preset);
  }

  @override
  HueVisualSpec lerp(ThemeExtension<HueVisualSpec>? other, double t) {
    if (other is! HueVisualSpec) return this;
    return t < 0.5 ? this : other;
  }
}
