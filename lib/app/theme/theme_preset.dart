import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HueThemePreset { minimal, glassy, highContrast }

extension HueThemePresetX on HueThemePreset {
  String get label {
    switch (this) {
      case HueThemePreset.minimal:
        return 'Minimal';
      case HueThemePreset.glassy:
        return 'Cam Etkisi';
      case HueThemePreset.highContrast:
        return 'Yüksek Kontrast';
    }
  }

  String get caption {
    switch (this) {
      case HueThemePreset.minimal:
        return 'Sakin ve nötr palet';
      case HueThemePreset.glassy:
        return 'Canlı geçişler ve parlama';
      case HueThemePreset.highContrast:
        return 'Keskin ayrım ve netlik';
    }
  }
}

final hueThemePresetProvider =
    StateNotifierProvider<HueThemePresetController, HueThemePreset>((ref) {
      return HueThemePresetController();
    });

class HueThemePresetController extends StateNotifier<HueThemePreset> {
  HueThemePresetController() : super(HueThemePreset.glassy);

  void setPreset(HueThemePreset preset) {
    if (state == preset) return;
    state = preset;
  }
}
