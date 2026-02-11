import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/tokens.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSend,
    required this.onOpenHue,
  });

  final ValueChanged<String> onSend;
  final VoidCallback onOpenHue;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController _controller = TextEditingController();
  bool _canSend = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          HueSpacing.sm,
          HueSpacing.xs,
          HueSpacing.sm,
          HueSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
          border: Border(
            top: BorderSide(color: HueColors.separator.withValues(alpha: 0.65)),
          ),
        ),
        child: Row(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(44, 44),
              onPressed: widget.onOpenHue,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: HueColors.blue.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(HueRadius.pill),
                ),
                child: const Icon(
                  CupertinoIcons.paintbrush,
                  color: HueColors.blue,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: HueSpacing.xs),
            Expanded(
              child: CupertinoTextField(
                controller: _controller,
                placeholder: 'Message',
                padding: const EdgeInsets.symmetric(
                  horizontal: HueSpacing.sm,
                  vertical: HueSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(HueRadius.pill),
                  border: Border.all(color: HueColors.separator),
                ),
                onChanged: (value) {
                  final next = value.trim().isNotEmpty;
                  if (_canSend == next) return;
                  setState(() {
                    _canSend = next;
                  });
                },
                onSubmitted: _send,
              ),
            ),
            const SizedBox(width: HueSpacing.xs),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(44, 44),
              onPressed: _canSend ? () => _send(_controller.text) : null,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _canSend
                      ? HueColors.blue
                      : HueColors.textSecondary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(HueRadius.pill),
                ),
                child: const Icon(
                  CupertinoIcons.arrow_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    widget.onSend(trimmed);
    _controller.clear();
    if (!_canSend) return;
    setState(() {
      _canSend = false;
    });
  }
}
