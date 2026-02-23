import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/models/hue_category.dart';
import '../../../shared/widgets/hue_category_badge.dart';
import '../../../shared/widgets/hue_logo.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSend,
    required this.onOpenHue,
    this.onOpenHueCategory,
    this.placeholder = 'Type a message...',
  });

  final ValueChanged<String> onSend;
  final VoidCallback onOpenHue;

  /// Called when a quick-pick category is tapped directly.
  final ValueChanged<HueCategory>? onOpenHueCategory;
  final String placeholder;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();
  bool _hasText = false;
  bool _showQuickPick = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (_hasText != hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  void _toggleQuickPick() {
    setState(() => _showQuickPick = !_showQuickPick);
  }

  void _pickCategory(HueCategory category) {
    setState(() => _showQuickPick = false);
    if (widget.onOpenHueCategory != null) {
      widget.onOpenHueCategory!(category);
    } else {
      widget.onOpenHue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0C0F14).withValues(alpha: 0.82)
                : Colors.white.withValues(alpha: 0.78),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Quick-pick category bar ──
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: _showQuickPick
                      ? _QuickPickBar(
                          onCategoryTap: _pickCategory,
                          onAllTap: () {
                            setState(() => _showQuickPick = false);
                            widget.onOpenHue();
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                // ── Composer row ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    HueSpacing.sm,
                    HueSpacing.xs,
                    HueSpacing.sm,
                    HueSpacing.xs,
                  ),
                  child: Row(
                    children: [
                      // ── Hue button (tap = toggle quick-pick, long-press = open full sheet) ──
                      GestureDetector(
                        onLongPress: widget.onOpenHue,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _toggleQuickPick,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: _showQuickPick
                                    ? [
                                        const Color(0xFF8B5CF6),
                                        const Color(0xFFA855F7),
                                      ]
                                    : HueColors.accentGradient,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6366F1).withValues(
                                    alpha: _showQuickPick ? 0.45 : 0.25,
                                  ),
                                  blurRadius: _showQuickPick ? 14 : 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: AnimatedRotation(
                              turns: _showQuickPick ? 0.125 : 0,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutBack,
                              child: Center(
                                child: _showQuickPick
                                    ? const Icon(
                                        CupertinoIcons.xmark,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : const HueLogo(
                                        size: 22,
                                        enableAnimation: false,
                                        showShadow: false,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: HueSpacing.xs),
                      // ── Text field ──
                      Expanded(
                        child: CupertinoTextField(
                          controller: _controller,
                          placeholder: widget.placeholder,
                          padding: const EdgeInsets.symmetric(
                            horizontal: HueSpacing.sm,
                            vertical: HueSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(HueRadius.pill),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.06),
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          placeholderStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: HueColors.textSecondary),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      const SizedBox(width: HueSpacing.xs),
                      // ── Send button ──
                      AnimatedScale(
                        scale: _hasText ? 1.0 : 0.85,
                        duration: const Duration(milliseconds: 180),
                        child: AnimatedOpacity(
                          opacity: _hasText ? 1.0 : 0.45,
                          duration: const Duration(milliseconds: 180),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: _send,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: _hasText
                                    ? const LinearGradient(
                                        colors: HueColors.accentGradient,
                                      )
                                    : null,
                                color: _hasText
                                    ? null
                                    : HueColors.textSecondary.withValues(
                                        alpha: 0.15,
                                      ),
                              ),
                              child: Icon(
                                CupertinoIcons.arrow_up,
                                size: 18,
                                color: _hasText
                                    ? Colors.white
                                    : HueColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal bar with 4 colored category quick-pick buttons + "All" option.
class _QuickPickBar extends StatelessWidget {
  const _QuickPickBar({required this.onCategoryTap, required this.onAllTap});

  final ValueChanged<HueCategory> onCategoryTap;
  final VoidCallback onAllTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HueSpacing.md,
        HueSpacing.xs,
        HueSpacing.md,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < HueCategory.values.length; i++)
            _QuickPickButton(
              category: HueCategory.values[i],
              onTap: () => onCategoryTap(HueCategory.values[i]),
              delay: (i * 40).ms,
            ),
          // "All templates" button
          CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onAllTap,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.square_grid_2x2,
                      size: 18,
                      color: Colors.white70,
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 200.ms, delay: 160.ms)
              .scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1, 1),
                duration: 200.ms,
                delay: 160.ms,
                curve: Curves.easeOutBack,
              ),
        ],
      ),
    );
  }
}

class _QuickPickButton extends StatelessWidget {
  const _QuickPickButton({
    required this.category,
    required this.onTap,
    required this.delay,
  });

  final HueCategory category;
  final VoidCallback onTap;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final color = category.color;

    return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, Color.lerp(color, Colors.black, 0.2)!],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: HueCategoryBadge(
                category: category,
                size: 24,
                isSelected: true,
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 200.ms, delay: delay)
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1, 1),
          duration: 200.ms,
          delay: delay,
          curve: Curves.easeOutBack,
        );
  }
}
