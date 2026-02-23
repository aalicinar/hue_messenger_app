// ignore_for_file: avoid_print

import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  final projectRoot = Directory.current.path;
  final iconsDir =
      '$projectRoot${Platform.pathSeparator}assets'
      '${Platform.pathSeparator}icons';
  final gradientPath =
      '$iconsDir${Platform.pathSeparator}hue_logo_gradient.png';

  final sourceFile = File(gradientPath);
  if (!sourceFile.existsSync()) {
    stderr.writeln('Source icon not found: $gradientPath');
    exitCode = 1;
    return;
  }

  final sourceBytes = sourceFile.readAsBytesSync();
  final source = img.decodePng(sourceBytes);
  if (source == null) {
    stderr.writeln('Could not decode PNG: $gradientPath');
    exitCode = 1;
    return;
  }

  final variants = <String, List<int>>{
    'blue': [0, 122, 255], // #007AFF
    'green': [52, 199, 89], // #34C759
    'yellow': [255, 184, 0], // #FFB800
    'red': [255, 59, 48], // #FF3B30
  };

  Directory(iconsDir).createSync(recursive: true);

  for (final entry in variants.entries) {
    final out = _recolorIcon(
      source,
      targetR: entry.value[0],
      targetG: entry.value[1],
      targetB: entry.value[2],
    );
    final outPath =
        '$iconsDir${Platform.pathSeparator}hue_logo_${entry.key}.png';
    File(outPath).writeAsBytesSync(img.encodePng(out));
    print('Generated: $outPath');
  }

  final white = _whiteIcon(source);
  final whitePath = '$iconsDir${Platform.pathSeparator}hue_logo_white.png';
  File(whitePath).writeAsBytesSync(img.encodePng(white));
  print('Generated: $whitePath');

  print('Done.');
}

img.Image _recolorIcon(
  img.Image source, {
  required int targetR,
  required int targetG,
  required int targetB,
}) {
  final out = img.Image.from(source);

  for (var y = 0; y < out.height; y++) {
    for (var x = 0; x < out.width; x++) {
      final px = source.getPixel(x, y);
      final a = px.a.toInt();
      if (a == 0) {
        out.setPixelRgba(x, y, 0, 0, 0, 0);
        continue;
      }

      final r = px.r.toInt();
      final g = px.g.toInt();
      final b = px.b.toInt();
      final lum = (0.2126 * r + 0.7152 * g + 0.0722 * b) / 255.0;

      // Keep shape depth while pushing category color strongly.
      const tint = 0.72;
      var nr = (r * (1 - tint) + targetR * tint).round();
      var ng = (g * (1 - tint) + targetG * tint).round();
      var nb = (b * (1 - tint) + targetB * tint).round();

      // Preserve highlights from the base icon.
      final highlight = lum * 0.22;
      nr = (nr + (255 - nr) * highlight).round().clamp(0, 255);
      ng = (ng + (255 - ng) * highlight).round().clamp(0, 255);
      nb = (nb + (255 - nb) * highlight).round().clamp(0, 255);

      out.setPixelRgba(x, y, nr, ng, nb, a);
    }
  }

  return out;
}

img.Image _whiteIcon(img.Image source) {
  final out = img.Image.from(source);
  for (var y = 0; y < out.height; y++) {
    for (var x = 0; x < out.width; x++) {
      final a = source.getPixel(x, y).a.toInt();
      out.setPixelRgba(x, y, 255, 255, 255, a);
    }
  }
  return out;
}
