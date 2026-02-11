import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/theme_preset.dart';
import '../../app/theme/tokens.dart';
import '../../shared/widgets/hue_backdrop.dart';
import '../../shared/widgets/hue_logo.dart';
import 'ack_replies_screen.dart';
import 'rate_limits_screen.dart';
import 'templates_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preset = ref.watch(hueThemePresetProvider);
    final presetController = ref.read(hueThemePresetProvider.notifier);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Ayarlar')),
      child: HueBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(HueSpacing.md),
            children: [
              HueGlassCard(
                child: Row(
                  children: [
                    const HueLogo(size: 48),
                    const SizedBox(width: HueSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hue Messenger',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: HueSpacing.xxs),
                          Text(
                            'Aşama A - Yerel Mock',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: HueColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: HueSpacing.xs),
              _SettingsTile(
                title: 'Tema Stili',
                subtitle: '${preset.label} - ${preset.caption}',
                onTap: () => _showThemePicker(
                  context: context,
                  selected: preset,
                  onSelected: presetController.setPreset,
                ),
              ),
              const SizedBox(height: HueSpacing.xs),
              _SettingsTile(
                title: 'Şablonlar',
                subtitle: 'H şablonlarını yönet',
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (_) => const TemplatesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: HueSpacing.xs),
              _SettingsTile(
                title: 'Gönderim Aralığı',
                subtitle: 'Kategori bekleme ayarları',
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (_) => const RateLimitsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: HueSpacing.xs),
              _SettingsTile(
                title: 'Onay Yanıtları',
                subtitle: 'En fazla 3 hızlı yanıt seçeneği',
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (_) => const AckRepliesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: HueSpacing.xs),
              _SettingsTile(title: 'Sürüm', subtitle: '1.0.0+1', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showThemePicker({
    required BuildContext context,
    required HueThemePreset selected,
    required ValueChanged<HueThemePreset> onSelected,
  }) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: const Text('Tema Stilini Seç'),
          message: const Text('Uygulamanın görsel yönünü seç.'),
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
            child: const Text('Vazgeç'),
          ),
        );
      },
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(HueSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(HueRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: HueSpacing.xxs),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: HueColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_right),
          ],
        ),
      ),
    );
  }
}
