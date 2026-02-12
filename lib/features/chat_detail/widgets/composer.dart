import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/tokens.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSend,
    required this.onOpenHue,
    this.placeholder = 'Type a message...',
  });

  final ValueChanged<String> onSend;
  final VoidCallback onOpenHue;
  final String placeholder;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();
  bool _hasText = false;

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            HueSpacing.sm,
            HueSpacing.xs,
            HueSpacing.sm,
            HueSpacing.xs,
          ),
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
            child: Row(
              children: [
                // ── Hue button ──
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: widget.onOpenHue,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: HueColors.accentGradient,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF6366F1,
                          ).withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/icons/hue_logo_gradient.png',
                          width: 22,
                          height: 22,
                          fit: BoxFit.cover,
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
                    placeholderStyle: Theme.of(context).textTheme.bodyMedium
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
                              : HueColors.textSecondary.withValues(alpha: 0.15),
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
        ),
      ),
    );
  }
}
