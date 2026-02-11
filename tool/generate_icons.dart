// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() {
  final inputPath = r'C:\Users\Mevlüt Cıhat\Desktop\HueHarfLogo.png';
  final outputDir = r'C:\Users\Mevlüt Cıhat\Desktop\hue_messenger\assets\icons';

  Directory(outputDir).createSync(recursive: true);

  final logoBytes = File(inputPath).readAsBytesSync();
  final logo = img.decodePng(logoBytes)!;

  const size = 1024;

  // Extract the H mask from the logo alpha channel.
  // alpha=255 → H letter (opaque white) → mask=255 (white)
  // alpha=0   → background (transparent) → mask=0  (colored bg)
  final mask = _extractHMask(logo, size);

  // Category solid colors
  final colors = <String, List<int>>{
    'red': [239, 68, 68],
    'yellow': [234, 179, 8],
    'green': [34, 197, 94],
    'blue': [59, 130, 246],
  };

  for (final entry in colors.entries) {
    print('Generating hue_logo_${entry.key}.png ...');
    final icon = _buildIcon(size, mask, (x, y) => entry.value);
    final path = '$outputDir${Platform.pathSeparator}hue_logo_${entry.key}.png';
    File(path).writeAsBytesSync(img.encodePng(icon));
    print('  -> $path');
  }

  // Gradient icon (blue → green → yellow → red, diagonal)
  print('Generating hue_logo_gradient.png ...');
  final stops = [
    [59, 130, 246], // blue
    [34, 197, 94], // green
    [234, 179, 8], // yellow
    [239, 68, 68], // red
  ];
  final icon = _buildIcon(size, mask, (x, y) {
    final t = ((x + y) / (2.0 * size)).clamp(0.0, 1.0);
    return _lerpGradient(stops, t);
  });
  final path = '$outputDir${Platform.pathSeparator}hue_logo_gradient.png';
  File(path).writeAsBytesSync(img.encodePng(icon));
  print('  -> $path');

  // Keep original
  File(
    '$outputDir${Platform.pathSeparator}hue_logo_white.png',
  ).writeAsBytesSync(logoBytes);

  print('\nAll icons generated!');
}

/// Extract H as a mask: alpha value directly = how much white H is here.
List<List<int>> _extractHMask(img.Image logo, int size) {
  final resized = img.copyResize(
    logo,
    width: size,
    height: size,
    interpolation: img.Interpolation.cubic,
  );

  final mask = List.generate(size, (_) => List.filled(size, 0));
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      // alpha=255 means H letter (opaque white), alpha=0 means background
      mask[y][x] = resized.getPixel(x, y).a.toInt().clamp(0, 255);
    }
  }
  return mask;
}

/// Build squircle icon: colored background + white H on top.
img.Image _buildIcon(
  int size,
  List<List<int>> hMask,
  List<int> Function(int x, int y) bgColorAt,
) {
  final icon = img.Image(width: size, height: size, numChannels: 4);

  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      if (!_inSquircle(x, y, size)) {
        icon.setPixelRgba(x, y, 0, 0, 0, 0); // transparent outside
        continue;
      }

      final bg = bgColorAt(x, y);
      final hAlpha = hMask[y][x] / 255.0; // 1.0 = white H, 0.0 = bg color

      // Blend: white(255) over bg color
      final r = (255 * hAlpha + bg[0] * (1 - hAlpha)).round().clamp(0, 255);
      final g = (255 * hAlpha + bg[1] * (1 - hAlpha)).round().clamp(0, 255);
      final b = (255 * hAlpha + bg[2] * (1 - hAlpha)).round().clamp(0, 255);

      icon.setPixelRgba(x, y, r, g, b, 255);
    }
  }
  return icon;
}

bool _inSquircle(int x, int y, int size) {
  final cx = size / 2.0;
  final nx = ((x - cx) / cx).abs();
  final ny = ((y - cx) / cx).abs();
  return pow(nx, 5) + pow(ny, 5) <= 1.0;
}

List<int> _lerpGradient(List<List<int>> stops, double t) {
  t = t.clamp(0.0, 1.0);
  final segs = stops.length - 1;
  final seg = (t * segs).floor().clamp(0, segs - 1);
  final lt = (t * segs) - seg;
  final c1 = stops[seg], c2 = stops[seg + 1];
  return [
    (c1[0] + (c2[0] - c1[0]) * lt).round().clamp(0, 255),
    (c1[1] + (c2[1] - c1[1]) * lt).round().clamp(0, 255),
    (c1[2] + (c2[2] - c1[2]) * lt).round().clamp(0, 255),
  ];
}
