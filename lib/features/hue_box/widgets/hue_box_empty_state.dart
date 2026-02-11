import 'package:flutter/material.dart';

import '../../../app/theme/tokens.dart';
import '../hue_box_controller.dart';

class HueBoxEmptyState extends StatelessWidget {
  const HueBoxEmptyState({super.key, required this.filter});

  final HueBoxFilter filter;

  @override
  Widget build(BuildContext context) {
    final message = filter == HueBoxFilter.all
        ? 'Hue Box şu an boş.'
        : 'Bu filtrede öğe yok.';

    return Center(
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: HueColors.textSecondary),
      ),
    );
  }
}
