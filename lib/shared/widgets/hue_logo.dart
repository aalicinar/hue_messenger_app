import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HueLogo extends StatelessWidget {
  const HueLogo({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.22),
          child: Image.asset(
            'assets/icons/hue_logo_gradient.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
          delay: 2000.ms,
          duration: 1800.ms,
          color: Colors.white.withValues(alpha: 0.15),
        );
  }
}
