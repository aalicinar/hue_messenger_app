import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/models/hue_category.dart';
import '../../../core/models/template.dart';
import '../../../shared/widgets/hue_category_badge.dart';

class HueSheet extends StatefulWidget {
  const HueSheet({
    super.key,
    required this.templates,
    required this.onTemplateSelected,
  });

  final List<Template> templates;
  final ValueChanged<Template> onTemplateSelected;

  @override
  State<HueSheet> createState() => _HueSheetState();
}

class _HueSheetState extends State<HueSheet> {
  HueCategory _selected = HueCategory.red;

  @override
  Widget build(BuildContext context) {
    final all =
        widget.templates.where((template) => !template.isHidden).toList()
          ..sort((a, b) => a.order.compareTo(b.order));
    final filtered = all
        .where((template) => template.category == _selected)
        .toList();
    final maxHeight = math.min(
      MediaQuery.of(context).size.height * 0.82,
      620.0,
    );

    return SafeArea(
      top: false,
      child: Container(
        height: maxHeight,
        padding: const EdgeInsets.fromLTRB(
          HueSpacing.md,
          HueSpacing.sm,
          HueSpacing.md,
          HueSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7FAFF), Color(0xFFF2F7FF), Color(0xFFEEF5FF)],
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(HueRadius.lg),
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.82)),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: HueColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(HueRadius.pill),
              ),
            ),
            const SizedBox(height: HueSpacing.sm),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _selected.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(HueRadius.pill),
                  ),
                  child: Icon(
                    CupertinoIcons.sparkles,
                    color: _selected.color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: HueSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'H Mesajı Gönder',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: HueSpacing.xxs),
                      Text(
                        'Bir şablona dokun, anında gönder',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: HueColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: HueSpacing.sm),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Bu kategoride şablon yok.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: HueColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: HueSpacing.xs),
                      itemBuilder: (context, index) {
                        final template = filtered[index];
                        return _TemplateCard(
                          template: template,
                          onTap: () => widget.onTemplateSelected(template),
                        );
                      },
                    ),
            ),
            const SizedBox(height: HueSpacing.xs),
            _CategoryPicker(
              selected: _selected,
              onChanged: (category) {
                setState(() {
                  _selected = category;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.onTap});

  final Template template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(HueSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(HueRadius.md),
          border: Border.all(
            color: template.category.color.withValues(alpha: 0.42),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: template.category.color.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(HueSpacing.xxs),
              decoration: BoxDecoration(
                color: template.category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(HueRadius.sm),
              ),
              child: HueCategoryBadge(category: template.category, size: 26),
            ),
            const SizedBox(width: HueSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.text,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: HueSpacing.xxs),
                  Text(
                    'Göndermek için dokun',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: HueColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: HueSpacing.sm),
            Icon(
              CupertinoIcons.arrow_up_circle_fill,
              color: template.category.color,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({required this.selected, required this.onChanged});

  final HueCategory selected;
  final ValueChanged<HueCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in HueCategory.values) ...[
            _CategoryChip(
              category: category,
              isSelected: selected == category,
              onTap: () => onChanged(category),
            ),
            if (category != HueCategory.values.last)
              const SizedBox(width: HueSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final HueCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(58, 44),
      onPressed: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: HueSpacing.sm,
          vertical: HueSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.2)
              : category.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(HueRadius.pill),
          border: Border.all(
            color: isSelected
                ? category.color
                : category.color.withValues(alpha: 0.28),
          ),
        ),
        child: HueCategoryBadge(
          category: category,
          size: 26,
          isSelected: isSelected,
        ),
      ),
    );
  }
}
