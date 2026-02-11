import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
import '../../app/theme/tokens.dart';
import '../../core/mock/mock_repo.dart';
import '../../core/models/chat.dart';
import '../../core/models/user.dart';
import '../../shared/widgets/hue_avatar.dart';
import '../../shared/widgets/hue_backdrop.dart';
import '../../shared/widgets/hue_logo.dart';
import '../chat_detail/chat_detail_screen.dart';
import 'chats_controller.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsState = ref.watch(chatsControllerProvider);
    final controller = ref.read(chatsControllerProvider.notifier);
    final repository = ref.watch(mockRepositoryProvider);
    final lang = ref.watch(localeProvider);
    final chats = chatsState.chats;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.get(lang, 'chats_title')),
      ),
      child: HueBackdrop(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              HueSpacing.md,
              HueSpacing.md,
              HueSpacing.md,
              0,
            ),
            child: Column(
              children: [
                HueGlassCard(
                  child: Row(
                    children: [
                      const HueLogo(size: 42),
                      const SizedBox(width: HueSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.get(lang, 'chats_header'),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              S
                                  .get(lang, 'chats_active_count')
                                  .replaceAll('{n}', '${chats.length}'),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: HueColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: HueSpacing.md),
                Expanded(
                  child: chats.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.chat_bubble_2,
                                size: 48,
                                color: HueColors.textSecondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              const SizedBox(height: HueSpacing.sm),
                              Text(
                                S.get(lang, 'chats_empty'),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: HueColors.textSecondary),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(
                            bottom: HueSpacing.xxl + HueSpacing.xl,
                          ),
                          itemCount: chats.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: HueSpacing.xs),
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            final otherUser = _otherUser(repository, chat);
                            return _ChatListItem(
                                  title:
                                      otherUser?.name ??
                                      S.get(lang, 'chats_unknown'),
                                  subtitle:
                                      chat.lastPreview ??
                                      S.get(lang, 'chats_no_message'),
                                  time: _formatTime(chat.lastAt),
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      CupertinoPageRoute<void>(
                                        builder: (_) =>
                                            ChatDetailScreen(chatId: chat.id),
                                      ),
                                    );
                                    controller.load();
                                  },
                                )
                                .animate()
                                .fadeIn(
                                  duration: 400.ms,
                                  delay: (80 * index).ms,
                                )
                                .slideY(
                                  begin: 0.12,
                                  end: 0,
                                  duration: 400.ms,
                                  delay: (80 * index).ms,
                                  curve: Curves.easeOutCubic,
                                );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: HueSpacing.sm),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      _showNewChatSheet(context, ref, lang);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: HueSpacing.md,
                        vertical: HueSpacing.sm + 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: HueColors.accentGradient,
                        ),
                        borderRadius: BorderRadius.circular(HueRadius.lg),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: HueSpacing.xs),
                          Text(
                            S.get(lang, 'chats_new'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
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

  Future<void> _showNewChatSheet(
    BuildContext context,
    WidgetRef ref,
    AppLanguage lang,
  ) async {
    final repository = ref.read(mockRepositoryProvider);
    final controller = ref.read(chatsControllerProvider.notifier);
    final candidates = repository
        .getUsers()
        .where((user) => user.id != MockRepository.currentUserId)
        .toList();

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: Text(S.get(lang, 'chats_new_title')),
          actions: [
            for (final user in candidates)
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(sheetContext).pop();
                  final chatId = controller.createOrGetChatWith(user.id);
                  await Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (_) => ChatDetailScreen(chatId: chatId),
                    ),
                  );
                  controller.load();
                },
                child: Text(user.name),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            isDefaultAction: true,
            child: Text(S.get(lang, 'cancel')),
          ),
        );
      },
    );
  }

  User? _otherUser(MockRepository repository, Chat chat) {
    for (final memberId in chat.memberIds) {
      if (memberId == MockRepository.currentUserId) continue;
      return repository.getUserById(memberId);
    }
    return null;
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('HH:mm').format(dateTime);
  }
}

class _ChatListItem extends StatelessWidget {
  const _ChatListItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: HueGlassCard(
        padding: const EdgeInsets.all(HueSpacing.sm + 2),
        child: Row(
          children: [
            HueAvatar(name: title, size: 48),
            const SizedBox(width: HueSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: HueColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: HueSpacing.xs),
            Text(
              time,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: HueColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
