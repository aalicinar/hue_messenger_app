import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import 'hue_backdrop.dart';
import 'hue_logo.dart';

/// Shared header card shown at the top of main screens.
///
/// Displays the [HueLogo] alongside a [title] and optional [subtitle].
/// An optional dot indicator is shown when [showDot] is true.
class HueScreenHeader extends StatelessWidget {
  const HueScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showDot = false,
    this.dotColor = HueColors.red,
  });

  final String title;
  final String? subtitle;
  final bool showDot;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return HueGlassCard(
      child: Row(
        children: [
          const HueLogo(size: 42),
          const SizedBox(width: HueSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (showDot) ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotColor,
                            boxShadow: HueShadows.glowFor(
                              dotColor,
                              intensity: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: HueColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
