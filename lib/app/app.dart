import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_provider.dart';
import 'router.dart';
import 'theme/hue_theme.dart';
import 'theme/theme_preset.dart';

class HueApp extends ConsumerWidget {
  const HueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preset = ref.watch(hueThemePresetProvider);
    final language = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Hue Messenger',
      theme: HueTheme.light(preset: preset),
      darkTheme: HueTheme.dark(preset: preset),
      themeMode: ThemeMode.system,
      locale: language.locale,
      supportedLocales: AppLanguage.values.map((l) => l.locale),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: HueRouter.onGenerateRoute,
      initialRoute: HueRouter.root,
      debugShowCheckedModeBanner: false,
    );
  }
}
