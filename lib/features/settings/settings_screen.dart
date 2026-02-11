import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
import '../../app/theme/theme_preset.dart';
import '../../app/theme/tokens.dart';
import '../../shared/widgets/hue_avatar.dart';
import '../../shared/widgets/hue_backdrop.dart';
import 'ack_replies_screen.dart';
import 'rate_limits_screen.dart';
import 'templates_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preset = ref.watch(hueThemePresetProvider);
    final presetController = ref.read(hueThemePresetProvider.notifier);
    final lang = ref.watch(localeProvider);
    final langController = ref.read(localeProvider.notifier);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.get(lang, 'settings_title')),
      ),
      child: HueBackdrop(
        child: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              HueSpacing.md,
              HueSpacing.md,
              HueSpacing.md,
              HueSpacing.xxl + HueSpacing.xl,
            ),
            children: [
              // ── Profile card ──
              HueGlassCard(
                padding: const EdgeInsets.all(HueSpacing.lg),
                child: Column(
                  children: [
                    const HueAvatar(name: 'Me', size: 64),
                    const SizedBox(height: HueSpacing.sm),
                    Text(
                      S.get(lang, 'settings_app_name'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: HueSpacing.sm,
                        vertical: HueSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(HueRadius.pill),
                      ),
                      child: Text(
                        S.get(lang, 'settings_phase'),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: HueSpacing.md),
              // ── Settings group ──
              HueGlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsRow(
                      icon: CupertinoIcons.paintbrush_fill,
                      iconColor: const Color(0xFF8B5CF6),
                      title: S.get(lang, 'settings_theme'),
                      subtitle: preset.label,
                      onTap: () => _showThemePicker(
                        context: context,
                        lang: lang,
                        selected: preset,
                        onSelected: presetController.setPreset,
                      ),
                    ),
                    _divider(context),
                    _SettingsRow(
                      icon: CupertinoIcons.globe,
                      iconColor: const Color(0xFF06B6D4),
                      title: S.get(lang, 'settings_language'),
                      subtitle: '${lang.flag} ${lang.label}',
                      onTap: () => _showLanguagePicker(
                        context: context,
                        lang: lang,
                        selected: lang,
                        onSelected: langController.setLanguage,
                      ),
                    ),
                    _divider(context),
                    _SettingsRow(
                      icon: CupertinoIcons.doc_text_fill,
                      iconColor: HueColors.blue,
                      title: S.get(lang, 'settings_templates'),
                      subtitle: S.get(lang, 'settings_templates_sub'),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (_) => const TemplatesScreen(),
                          ),
                        );
                      },
                    ),
                    _divider(context),
                    _SettingsRow(
                      icon: CupertinoIcons.timer,
                      iconColor: HueColors.yellow,
                      title: S.get(lang, 'settings_rate_limit'),
                      subtitle: S.get(lang, 'settings_rate_limit_sub'),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (_) => const RateLimitsScreen(),
                          ),
                        );
                      },
                    ),
                    _divider(context),
                    _SettingsRow(
                      icon: CupertinoIcons.hand_thumbsup_fill,
                      iconColor: HueColors.green,
                      title: S.get(lang, 'settings_ack_replies'),
                      subtitle: S.get(lang, 'settings_ack_replies_sub'),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (_) => const AckRepliesScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: HueSpacing.md),
              HueGlassCard(
                padding: EdgeInsets.zero,
                child: _SettingsRow(
                  icon: CupertinoIcons.info_circle_fill,
                  iconColor: HueColors.textSecondary,
                  title: S.get(lang, 'settings_version'),
                  subtitle: '1.0.0+1',
                  showChevron: false,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(height: 1, color: Theme.of(context).dividerColor),
    );
  }

  Future<void> _showThemePicker({
    required BuildContext context,
    required AppLanguage lang,
    required HueThemePreset selected,
    required ValueChanged<HueThemePreset> onSelected,
  }) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: Text(S.get(lang, 'theme_picker_title')),
          message: Text(S.get(lang, 'theme_picker_message')),
          actions: [
            for (final preset in HueThemePreset.values)
              CupertinoActionSheetAction(
                isDefaultAction: preset == selected,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  onSelected(preset);
                },
                child: Text('${preset.label}  |  ${preset.caption}'),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            isDefaultAction: true,
            child: Text(S.get(lang, 'cancel')),
          ),
        );
      },
    );
  }

  Future<void> _showLanguagePicker({
    required BuildContext context,
    required AppLanguage lang,
    required AppLanguage selected,
    required ValueChanged<AppLanguage> onSelected,
  }) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: Text(S.get(lang, 'settings_language_title')),
          actions: [
            for (final language in AppLanguage.values)
              CupertinoActionSheetAction(
                isDefaultAction: language == selected,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  onSelected(language);
                },
                child: Text('${language.flag}  ${language.label}'),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            isDefaultAction: true,
            child: Text(S.get(lang, 'cancel')),
          ),
        );
      },
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showChevron = true,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: HueSpacing.md,
          vertical: HueSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 17, color: iconColor),
            ),
            const SizedBox(width: HueSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: HueColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron)
              Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: HueColors.textSecondary.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}
