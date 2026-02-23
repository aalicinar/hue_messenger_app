import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
import '../../app/theme/theme_preset.dart';
import '../../app/theme/tokens.dart';
import '../../core/mock/mock_repo.dart';
import '../../shared/widgets/hue_avatar.dart';
import '../../shared/widgets/hue_backdrop.dart';
import 'ack_replies_screen.dart';
import 'rate_limits_screen.dart';
import 'templates_screen.dart';

final _settingsRevisionProvider = StreamProvider<int>((ref) {
  final repository = ref.watch(mockRepositoryProvider);
  return repository.watchRevision();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(_settingsRevisionProvider);
    final preset = ref.watch(hueThemePresetProvider);
    final presetController = ref.read(hueThemePresetProvider.notifier);
    final lang = ref.watch(localeProvider);
    final langController = ref.read(localeProvider.notifier);
    final repository = ref.watch(mockRepositoryProvider);
    final currentUser = repository.getCurrentUser();
    final statusText = (currentUser.status ?? '').trim();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
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
              HueGlassCard(
                padding: const EdgeInsets.all(HueSpacing.lg),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        HueAvatar(
                          name: currentUser.name,
                          size: 72,
                          avatarUrl: currentUser.avatarUrl,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            onPressed: () => _showAvatarPicker(
                              context: context,
                              repository: repository,
                              lang: lang,
                            ),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4F46E5),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                CupertinoIcons.camera_fill,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: HueSpacing.sm),
                    Text(
                      currentUser.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusText.isEmpty
                          ? _copy(lang, tr: 'Durum eklenmedi', en: 'No status')
                          : statusText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: HueColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: HueSpacing.sm),
                    Wrap(
                      spacing: HueSpacing.xs,
                      runSpacing: HueSpacing.xs,
                      children: [
                        _QuickActionChip(
                          label: _copy(
                            lang,
                            tr: 'Profil fotografi',
                            en: 'Profile photo',
                          ),
                          icon: CupertinoIcons.photo_fill_on_rectangle_fill,
                          onTap: () => _showAvatarPicker(
                            context: context,
                            repository: repository,
                            lang: lang,
                          ),
                        ),
                        _QuickActionChip(
                          label: _copy(
                            lang,
                            tr: 'Adi duzenle',
                            en: 'Edit name',
                          ),
                          icon: CupertinoIcons.person_crop_circle,
                          onTap: () => _editDisplayName(
                            context: context,
                            repository: repository,
                            lang: lang,
                            currentName: currentUser.name,
                          ),
                        ),
                        _QuickActionChip(
                          label: _copy(
                            lang,
                            tr: 'Durumu duzenle',
                            en: 'Edit status',
                          ),
                          icon: CupertinoIcons.chat_bubble_text_fill,
                          onTap: () => _editStatus(
                            context: context,
                            repository: repository,
                            lang: lang,
                            currentStatus: statusText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: HueSpacing.md),
              HueGlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsRow(
                      icon: CupertinoIcons.person_fill,
                      iconColor: const Color(0xFF4F46E5),
                      title: _copy(lang, tr: 'Gorunen ad', en: 'Display name'),
                      subtitle: currentUser.name,
                      onTap: () => _editDisplayName(
                        context: context,
                        repository: repository,
                        lang: lang,
                        currentName: currentUser.name,
                      ),
                    ),
                    _divider(context),
                    _SettingsRow(
                      icon: CupertinoIcons.chat_bubble_2_fill,
                      iconColor: const Color(0xFF0EA5E9),
                      title: _copy(lang, tr: 'Durum', en: 'Status'),
                      subtitle: statusText.isEmpty
                          ? _copy(lang, tr: 'Durum ekle', en: 'Add a status')
                          : statusText,
                      onTap: () => _editStatus(
                        context: context,
                        repository: repository,
                        lang: lang,
                        currentStatus: statusText,
                      ),
                    ),
                    _divider(context),
                    _SettingsRow(
                      icon: CupertinoIcons.photo_fill,
                      iconColor: const Color(0xFFF97316),
                      title: _copy(
                        lang,
                        tr: 'Profil fotografi sec',
                        en: 'Select profile photo',
                      ),
                      subtitle: _avatarSubtitle(
                        lang: lang,
                        avatarAsset: currentUser.avatarUrl,
                      ),
                      onTap: () => _showAvatarPicker(
                        context: context,
                        repository: repository,
                        lang: lang,
                      ),
                    ),
                    _divider(context),
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
                      subtitle: lang.label,
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
                child: Column(
                  children: [
                    _SettingsSwitchRow(
                      icon: CupertinoIcons.eye_fill,
                      iconColor: const Color(0xFF3B82F6),
                      title: _copy(
                        lang,
                        tr: 'Profil fotografi gorunurlugu',
                        en: 'Profile photo visibility',
                      ),
                      subtitle: _copy(
                        lang,
                        tr: 'Diger kisiler profil fotografini gorebilir',
                        en: 'Other users can see your profile photo',
                      ),
                      value: repository.getProfilePhotoVisible(),
                      onChanged: repository.setProfilePhotoVisible,
                    ),
                    _divider(context),
                    _SettingsSwitchRow(
                      icon: CupertinoIcons.checkmark_seal_fill,
                      iconColor: const Color(0xFF14B8A6),
                      title: _copy(
                        lang,
                        tr: 'Okundu bilgisi',
                        en: 'Read receipts',
                      ),
                      subtitle: _copy(
                        lang,
                        tr: 'Mesajlarin gorulme durumunu paylas',
                        en: 'Share seen status for messages',
                      ),
                      value: repository.getReadReceiptsEnabled(),
                      onChanged: repository.setReadReceiptsEnabled,
                    ),
                    _divider(context),
                    _SettingsSwitchRow(
                      icon: CupertinoIcons.text_cursor,
                      iconColor: const Color(0xFFF59E0B),
                      title: _copy(
                        lang,
                        tr: 'Yaziyor gostergesi',
                        en: 'Typing indicator',
                      ),
                      subtitle: _copy(
                        lang,
                        tr: 'Yazma durumunu goster',
                        en: 'Show when you are typing',
                      ),
                      value: repository.getTypingIndicatorEnabled(),
                      onChanged: repository.setTypingIndicatorEnabled,
                    ),
                    _divider(context),
                    _SettingsSwitchRow(
                      icon: CupertinoIcons.bell_slash_fill,
                      iconColor: const Color(0xFFEF4444),
                      title: _copy(
                        lang,
                        tr: 'Sessiz saatler',
                        en: 'Quiet hours',
                      ),
                      subtitle: _copy(
                        lang,
                        tr: 'Odak aninda bildirimleri kis',
                        en: 'Mute alerts during focus time',
                      ),
                      value: repository.getQuietHoursEnabled(),
                      onChanged: repository.setQuietHoursEnabled,
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

  Future<void> _editDisplayName({
    required BuildContext context,
    required MockRepository repository,
    required AppLanguage lang,
    required String currentName,
  }) async {
    final value = await _showTextEditDialog(
      context: context,
      title: _copy(lang, tr: 'Gorunen ad', en: 'Display name'),
      actionLabel: _copy(lang, tr: 'Kaydet', en: 'Save'),
      cancelLabel: _copy(lang, tr: 'Vazgec', en: 'Cancel'),
      placeholder: _copy(lang, tr: 'Adinizi yazin', en: 'Enter your name'),
      initialValue: currentName,
      maxLength: 24,
    );
    if (value == null) return;

    try {
      repository.updateCurrentUserName(value);
    } on FormatException catch (error) {
      if (!context.mounted) return;
      await _showErrorDialog(
        context: context,
        title: _copy(lang, tr: 'Kaydedilemedi', en: 'Could not save'),
        message: error.message,
        lang: lang,
      );
    }
  }

  Future<void> _editStatus({
    required BuildContext context,
    required MockRepository repository,
    required AppLanguage lang,
    required String currentStatus,
  }) async {
    final value = await _showTextEditDialog(
      context: context,
      title: _copy(lang, tr: 'Durum', en: 'Status'),
      actionLabel: _copy(lang, tr: 'Kaydet', en: 'Save'),
      cancelLabel: _copy(lang, tr: 'Vazgec', en: 'Cancel'),
      placeholder: _copy(
        lang,
        tr: 'Kisa bir durum yazin',
        en: 'Write a short status',
      ),
      initialValue: currentStatus,
      maxLength: 40,
    );
    if (value == null) return;

    try {
      repository.updateCurrentUserStatus(value);
    } on FormatException catch (error) {
      if (!context.mounted) return;
      await _showErrorDialog(
        context: context,
        title: _copy(lang, tr: 'Kaydedilemedi', en: 'Could not save'),
        message: error.message,
        lang: lang,
      );
    }
  }

  Future<void> _showAvatarPicker({
    required BuildContext context,
    required MockRepository repository,
    required AppLanguage lang,
  }) async {
    final currentAvatar = repository.getCurrentUser().avatarUrl;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: Text(_copy(lang, tr: 'Profil fotografi', en: 'Profile photo')),
          message: Text(
            _copy(
              lang,
              tr: 'Mock onizleme icin bir avatar sec.',
              en: 'Choose an avatar for mock preview.',
            ),
          ),
          actions: [
            for (final preset in _avatarPresets)
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  repository.updateCurrentUserAvatar(preset.asset);
                },
                child: Text(
                  preset.label(lang) +
                      (currentAvatar == preset.asset
                          ? _copy(lang, tr: ' (secili)', en: ' (selected)')
                          : ''),
                ),
              ),
            if (currentAvatar != null)
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  repository.updateCurrentUserAvatar(null);
                },
                child: Text(
                  _copy(lang, tr: 'Fotografi kaldir', en: 'Remove photo'),
                ),
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

  Future<String?> _showTextEditDialog({
    required BuildContext context,
    required String title,
    required String actionLabel,
    required String cancelLabel,
    required String placeholder,
    required int maxLength,
    String initialValue = '',
  }) async {
    final controller = TextEditingController(text: initialValue);
    final result = await showCupertinoDialog<String>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: HueSpacing.sm),
            child: CupertinoTextField(
              controller: controller,
              autofocus: true,
              maxLength: maxLength,
              placeholder: placeholder,
              onSubmitted: (_) =>
                  Navigator.of(dialogContext).pop(controller.text),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(cancelLabel),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(controller.text),
              child: Text(actionLabel),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }

  Future<void> _showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    required AppLanguage lang,
  }) async {
    await showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(S.get(lang, 'common_ok')),
            ),
          ],
        );
      },
    );
  }

  String _avatarSubtitle({
    required AppLanguage lang,
    required String? avatarAsset,
  }) {
    if (avatarAsset == null) {
      return _copy(lang, tr: 'Secili fotograf yok', en: 'No selected photo');
    }
    final preset = _avatarPresets.where((it) => it.asset == avatarAsset);
    if (preset.isEmpty) {
      return _copy(lang, tr: 'Ozel avatar', en: 'Custom avatar');
    }
    return preset.first.label(lang);
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
                child: Text(language.label),
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

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HueSpacing.sm,
          vertical: HueSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(HueRadius.pill),
          border: Border.all(
            color: const Color(0xFF6366F1).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF4F46E5)),
            const SizedBox(width: HueSpacing.xxs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFF4338CA),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarPreset {
  const _AvatarPreset({
    required this.asset,
    required this.labelTr,
    required this.labelEn,
  });

  final String asset;
  final String labelTr;
  final String labelEn;

  String label(AppLanguage lang) {
    return lang == AppLanguage.turkish ? labelTr : labelEn;
  }
}

const List<_AvatarPreset> _avatarPresets = <_AvatarPreset>[
  _AvatarPreset(
    asset: 'preset:spectrum',
    labelTr: 'Spektrum',
    labelEn: 'Spectrum',
  ),
  _AvatarPreset(asset: 'preset:ember', labelTr: 'Ates', labelEn: 'Ember'),
  _AvatarPreset(asset: 'preset:amber', labelTr: 'Kehri', labelEn: 'Amber'),
  _AvatarPreset(asset: 'preset:mint', labelTr: 'Nane', labelEn: 'Mint'),
  _AvatarPreset(asset: 'preset:sky', labelTr: 'Gok', labelEn: 'Sky'),
];

String _copy(AppLanguage lang, {required String tr, required String en}) {
  return lang == AppLanguage.turkish ? tr : en;
}
