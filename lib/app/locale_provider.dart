import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supported locales for the app.
enum AppLanguage {
  turkish('tr', 'Türkçe', '🇹🇷'),
  english('en', 'English', '🇬🇧'),
  russian('ru', 'Русский', '🇷🇺'),
  japanese('ja', '日本語', '🇯🇵'),
  chinese('zh', '中文', '🇨🇳');

  const AppLanguage(this.code, this.label, this.flag);

  final String code;
  final String label;
  final String flag;

  Locale get locale => Locale(code);
}

final localeProvider = StateNotifierProvider<LocaleController, AppLanguage>((
  ref,
) {
  return LocaleController();
});

class LocaleController extends StateNotifier<AppLanguage> {
  LocaleController() : super(AppLanguage.turkish);

  void setLanguage(AppLanguage language) {
    if (state == language) return;
    state = language;
  }
}
