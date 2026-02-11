import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'theme_preset.dart';
import 'tokens.dart';

class HueTheme {
  const HueTheme._();

  static const List<String> _iosFirstFonts = [
    '.SF Pro Text',
    '.SF UI Text',
    'SF Pro Text',
    'Helvetica Neue',
    'Arial',
  ];

  static ThemeData light({required HueThemePreset preset}) {
    final seed = _seedColorFor(preset);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _scaffoldLightFor(preset),
      dividerColor: HueColors.separator,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.45,
          height: 1.06,
          fontFamilyFallback: _iosFirstFonts,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
          fontFamilyFallback: _iosFirstFonts,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.15,
          fontFamilyFallback: _iosFirstFonts,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.08,
          fontFamilyFallback: _iosFirstFonts,
        ),
        bodyMedium: TextStyle(
          height: 1.36,
          letterSpacing: -0.04,
          fontFamilyFallback: _iosFirstFonts,
        ),
        bodySmall: TextStyle(height: 1.33, fontFamilyFallback: _iosFirstFonts),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: colorScheme.primary,
        barBackgroundColor: Colors.white.withValues(alpha: 0.78),
        textTheme: CupertinoTextThemeData(
          textStyle: const TextStyle(
            inherit: false,
            fontFamilyFallback: _iosFirstFonts,
          ),
          navTitleTextStyle: const TextStyle(
            inherit: false,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            fontFamilyFallback: _iosFirstFonts,
          ),
          navLargeTitleTextStyle: const TextStyle(
            inherit: false,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            fontFamilyFallback: _iosFirstFonts,
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
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _scaffoldDarkFor(preset),
      dividerColor: HueColors.separator.withValues(alpha: 0.35),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.45,
          height: 1.06,
          fontFamilyFallback: _iosFirstFonts,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
          fontFamilyFallback: _iosFirstFonts,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.15,
          fontFamilyFallback: _iosFirstFonts,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.08,
          fontFamilyFallback: _iosFirstFonts,
        ),
        bodyMedium: TextStyle(
          height: 1.36,
          letterSpacing: -0.04,
          fontFamilyFallback: _iosFirstFonts,
        ),
        bodySmall: TextStyle(height: 1.33, fontFamilyFallback: _iosFirstFonts),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: colorScheme.primary,
        barBackgroundColor: const Color(0xFF0F1624).withValues(alpha: 0.76),
        textTheme: CupertinoTextThemeData(
          textStyle: const TextStyle(
            inherit: false,
            fontFamilyFallback: _iosFirstFonts,
          ),
          navTitleTextStyle: const TextStyle(
            inherit: false,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            fontFamilyFallback: _iosFirstFonts,
          ),
          navLargeTitleTextStyle: const TextStyle(
            inherit: false,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            fontFamilyFallback: _iosFirstFonts,
          ),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[HueVisualSpec(preset: preset)],
    );
  }

  static Color _seedColorFor(HueThemePreset preset) {
    switch (preset) {
      case HueThemePreset.minimal:
        return HueColors.blue;
      case HueThemePreset.glassy:
        return const Color(0xFF31A0FF);
      case HueThemePreset.highContrast:
        return const Color(0xFF0059FF);
    }
  }

  static Color _scaffoldLightFor(HueThemePreset preset) {
    switch (preset) {
      case HueThemePreset.minimal:
        return const Color(0xFFF7F8FA);
      case HueThemePreset.glassy:
        return const Color(0xFFF3F7FF);
      case HueThemePreset.highContrast:
        return const Color(0xFFF1F4FA);
    }
  }

  static Color _scaffoldDarkFor(HueThemePreset preset) {
    switch (preset) {
      case HueThemePreset.minimal:
        return HueColors.neutralBackgroundDark;
      case HueThemePreset.glassy:
        return const Color(0xFF111827);
      case HueThemePreset.highContrast:
        return const Color(0xFF0A0D12);
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
