import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

enum HueCategory { red, yellow, green, blue }

extension HueCategoryX on HueCategory {
  String get label {
    switch (this) {
      case HueCategory.red:
        return 'Kırmızı';
      case HueCategory.yellow:
        return 'Sarı';
      case HueCategory.green:
        return 'Yeşil';
      case HueCategory.blue:
        return 'Mavi';
    }
  }

  int get priority {
    switch (this) {
      case HueCategory.red:
        return 4;
      case HueCategory.yellow:
        return 3;
      case HueCategory.green:
        return 2;
      case HueCategory.blue:
        return 1;
    }
  }

  Color get color {
    switch (this) {
      case HueCategory.red:
        return HueColors.red;
      case HueCategory.yellow:
        return HueColors.yellow;
      case HueCategory.green:
        return HueColors.green;
      case HueCategory.blue:
        return HueColors.blue;
    }
  }

  String get iconAsset {
    switch (this) {
      case HueCategory.red:
        return 'assets/icons/hue_logo_red.png';
      case HueCategory.yellow:
        return 'assets/icons/hue_logo_yellow.png';
      case HueCategory.green:
        return 'assets/icons/hue_logo_green.png';
      case HueCategory.blue:
        return 'assets/icons/hue_logo_blue.png';
    }
  }
}
