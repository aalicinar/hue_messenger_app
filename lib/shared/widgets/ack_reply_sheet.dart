import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
import '../../app/theme/tokens.dart';
import 'hue_backdrop.dart';

Future<String?> showAckReplySheet({
  required BuildContext context,
  required AppLanguage lang,
  required List<String> replyOptions,
  required String title,
  required String message,
  required String cancelLabel,
}) async {
  final options = replyOptions.isEmpty
      ? _defaultReplyOptions(lang)
      : replyOptions;
  final inputController = TextEditingController();
  final inputFocusNode = FocusNode();
  var showCustomComposer = false;
  String? errorText;

  final selected = await showCupertinoModalPopup<String>(
    context: context,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (popupContext, setPopupState) {
          void submitCustomReply() {
            final normalized = inputController.text.trim();
            final validation = _validateCustomReply(lang, normalized);
            if (validation != null) {
              setPopupState(() => errorText = validation);
              return;
            }
            Navigator.of(sheetContext).pop(normalized);
          }

          return Material(
            color: Colors.transparent,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  HueSpacing.sm,
                  HueSpacing.md,
                  HueSpacing.sm,
                  HueSpacing.md,
                ),
                child: HueGlassCard(
                  padding: const EdgeInsets.all(HueSpacing.md),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: HueSpacing.xxs),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: HueColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: HueSpacing.sm),
                      Wrap(
                        spacing: HueSpacing.xs,
                        runSpacing: HueSpacing.xs,
                        children: [
                          for (final option in options)
                            _AckOptionChip(
                              label: option,
                              onTap: () =>
                                  Navigator.of(sheetContext).pop(option),
                            ),
                          _AckOptionChip(
                            label: '${S.get(lang, 'common_other')}...',
                            leadingIcon: CupertinoIcons.pencil,
                            onTap: () {
                              setPopupState(() {
                                showCustomComposer = true;
                                errorText = null;
                              });
                              Future<void>.delayed(
                                const Duration(milliseconds: 60),
                                () => inputFocusNode.requestFocus(),
                              );
                            },
                          ),
                        ],
                      ),
                      if (showCustomComposer) ...[
                        const SizedBox(height: HueSpacing.sm),
                        CupertinoTextField(
                          controller: inputController,
                          focusNode: inputFocusNode,
                          maxLength: 24,
                          placeholder: S.get(lang, 'ack_sheet_custom_placeholder'),
                          onChanged: (_) {
                            if (errorText == null) return;
                            setPopupState(() => errorText = null);
                          },
                          onSubmitted: (_) => submitCustomReply(),
                        ),
                        if (errorText != null) ...[
                          const SizedBox(height: HueSpacing.xxs),
                          Text(
                            errorText!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: HueColors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                        const SizedBox(height: HueSpacing.xs),
                        Row(
                          children: [
                            Expanded(
                              child: CupertinoButton(
                                onPressed: () {
                                  setPopupState(() {
                                    showCustomComposer = false;
                                    errorText = null;
                                    inputController.clear();
                                  });
                                  FocusScope.of(popupContext).unfocus();
                                },
                                child: Text(
                                  S.get(lang, 'ack_sheet_use_quick'),
                                ),
                              ),
                            ),
                            const SizedBox(width: HueSpacing.xs),
                            Expanded(
                              child: CupertinoButton.filled(
                                onPressed: submitCustomReply,
                                child: Text(
                                  S.get(lang, 'common_send'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: HueSpacing.xs),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CupertinoButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: Text(cancelLabel),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );

  inputController.dispose();
  inputFocusNode.dispose();
  return selected;
}

class _AckOptionChip extends StatelessWidget {
  const _AckOptionChip({
    required this.label,
    required this.onTap,
    this.leadingIcon,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HueSpacing.sm,
          vertical: HueSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(HueRadius.pill),
          border: Border.all(
            color: const Color(0xFF6366F1).withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 14, color: const Color(0xFF6366F1)),
              const SizedBox(width: HueSpacing.xxs),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF4338CA),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> _defaultReplyOptions(AppLanguage lang) {
  return <String>[
    S.get(lang, 'common_ok'),
    S.get(lang, 'common_yes'),
    S.get(lang, 'common_no'),
  ];
}

String? _validateCustomReply(AppLanguage lang, String value) {
  if (value.isEmpty) {
    return S.get(lang, 'ack_sheet_reply_empty');
  }
  if (value.length > 24) {
    return S.get(lang, 'ack_sheet_reply_too_long');
  }
  return null;
}
