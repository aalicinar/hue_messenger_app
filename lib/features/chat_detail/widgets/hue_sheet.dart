import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/models/hue_category.dart';
import '../../../core/models/template.dart';
import '../../../shared/widgets/hue_category_badge.dart';

class HueSheet extends StatefulWidget {
  const HueSheet({
    super.key,
    required this.templates,
    required this.onTemplateSelected,
    this.title = 'Select H Template',
    this.allLabel = 'All',
    this.emptyLabel = 'No templates in this category.',
    this.categoryLabelBuilder,
  });

  final List<Template> templates;
  final ValueChanged<Template> onTemplateSelected;
  final String title;
  final String allLabel;
  final String emptyLabel;
  final String Function(HueCategory category)? categoryLabelBuilder;

  @override
  State<HueSheet> createState() => _HueSheetState();
}

class _HueSheetState extends State<HueSheet> {
  HueCategory? _selectedCategory;

  List<Template> get _filteredTemplates {
    if (_selectedCategory == null) return widget.templates;
    return widget.templates
        .where((template) => template.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = MediaQuery.of(context).size.height * 0.55;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(HueRadius.xl),
        topRight: Radius.circular(HueRadius.xl),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0C0F14).withValues(alpha: 0.88)
                : Colors.white.withValues(alpha: 0.82),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(HueRadius.xl),
              topRight: Radius.circular(HueRadius.xl),
            ),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                width: 1.5,
              ),
            ),
          ),
          child: Column(
            children: [
              // ── Drag handle ──
              Padding(
                padding: const EdgeInsets.only(top: HueSpacing.sm),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(HueRadius.pill),
                  ),
                ),
              ),
              const SizedBox(height: HueSpacing.sm),
              // ── Title ──
              Text(
                widget.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: HueSpacing.sm),
              // ── Category picker ──
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: HueSpacing.md,
                  ),
                  children: [
                    _CategoryChip(
                      label: widget.allLabel,
                      isSelected: _selectedCategory == null,
                      onTap: () => setState(() => _selectedCategory = null),
                    ),
                    const SizedBox(width: HueSpacing.xs),
                    for (final category in HueCategory.values) ...[
                      _CategoryChip(
                        category: category,
                        isSelected: _selectedCategory == category,
                        onTap: () =>
                            setState(() => _selectedCategory = category),
                      ),
                      const SizedBox(width: HueSpacing.xs),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: HueSpacing.sm),
              // ── Templates list ──
              Expanded(
                child: _filteredTemplates.isEmpty
                    ? Center(
                        child: Text(
                          widget.emptyLabel,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: HueColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: HueSpacing.md,
                        ),
                        itemCount: _filteredTemplates.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: HueSpacing.xs),
                        itemBuilder: (context, index) {
                          final template = _filteredTemplates[index];
                          return _TemplateCard(
                                template: template,
                                categoryLabel:
                                    widget.categoryLabelBuilder?.call(
                                      template.category,
                                    ) ??
                                    template.category.label,
                                onTap: () =>
                                    widget.onTemplateSelected(template),
                              )
                              .animate()
                              .fadeIn(duration: 300.ms, delay: (50 * index).ms)
                              .slideY(
                                begin: 0.08,
                                end: 0,
                                duration: 300.ms,
                                delay: (50 * index).ms,
                                curve: Curves.easeOutCubic,
                              );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    this.label,
    this.category,
    required this.isSelected,
    required this.onTap,
  });

  final String? label;
  final HueCategory? category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = category?.color ?? const Color(0xFF6366F1);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: HueSpacing.sm,
          vertical: HueSpacing.xs,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color, color.withValues(alpha: 0.8)])
              : null,
          color: isSelected ? null : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(HueRadius.pill),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : color.withValues(alpha: 0.2),
          ),
        ),
        child: label != null
            ? Text(
                label!,
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              )
            : HueCategoryBadge(
                category: category!,
                size: 22,
                isSelected: isSelected,
              ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.categoryLabel,
    required this.onTap,
  });

  final Template template;
  final String categoryLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = template.category.color;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(HueSpacing.sm),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(HueRadius.md),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : color.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            HueCategoryBadge(category: template.category, size: 30),
            const SizedBox(width: HueSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    categoryLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: HueColors.textSecondary.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
