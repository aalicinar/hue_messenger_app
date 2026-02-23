// ignore_for_file: avoid_print

import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  final projectRoot = Directory.current.path;
  final sep = Platform.pathSeparator;
  final sourcePath =
      '$projectRoot${sep}assets${sep}icons${sep}hue_logo_gradient.png';
  final webDir = '$projectRoot${sep}web';
  final webIconsDir = '$webDir${sep}icons';

  final sourceFile = File(sourcePath);
  if (!sourceFile.existsSync()) {
    stderr.writeln('Source icon not found: $sourcePath');
    exitCode = 1;
    return;
  }

  final sourceBytes = sourceFile.readAsBytesSync();
  final source = img.decodePng(sourceBytes);
  if (source == null) {
    stderr.writeln('Could not decode PNG: $sourcePath');
    exitCode = 1;
    return;
  }

  Directory(webIconsDir).createSync(recursive: true);

  // Generate web icons at various sizes
  final targets = <String, int>{
    '$webDir${sep}favicon.png': 32,
    '$webDir${sep}app-icon.png': 512,
    '$webIconsDir${sep}Icon-192.png': 192,
    '$webIconsDir${sep}Icon-512.png': 512,
    '$webIconsDir${sep}Icon-maskable-192.png': 192,
    '$webIconsDir${sep}Icon-maskable-512.png': 512,
  };

  for (final entry in targets.entries) {
    final resized = img.copyResize(
      source,
      width: entry.value,
      height: entry.value,
      interpolation: img.Interpolation.cubic,
    );
    File(entry.key).writeAsBytesSync(img.encodePng(resized));
    print('Generated ${entry.value}x${entry.value}: ${entry.key}');
  }

  print('Done. All web icons updated.');
}
