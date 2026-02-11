import 'hue_category.dart';

class RateLimits {
  const RateLimits({
    required this.redSeconds,
    required this.yellowSeconds,
    required this.greenSeconds,
    required this.blueSeconds,
  });

  final int redSeconds;
  final int yellowSeconds;
  final int greenSeconds;
  final int blueSeconds;

  int secondsFor(HueCategory category) {
    switch (category) {
      case HueCategory.red:
        return redSeconds;
      case HueCategory.yellow:
        return yellowSeconds;
      case HueCategory.green:
        return greenSeconds;
      case HueCategory.blue:
        return blueSeconds;
    }
  }

  RateLimits copyWith({
    int? redSeconds,
    int? yellowSeconds,
    int? greenSeconds,
    int? blueSeconds,
  }) {
    return RateLimits(
      redSeconds: redSeconds ?? this.redSeconds,
      yellowSeconds: yellowSeconds ?? this.yellowSeconds,
      greenSeconds: greenSeconds ?? this.greenSeconds,
      blueSeconds: blueSeconds ?? this.blueSeconds,
    );
  }
}
