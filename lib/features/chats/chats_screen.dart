import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme/tokens.dart';
import '../../core/mock/mock_repo.dart';
import '../../core/models/chat.dart';
import '../../core/models/user.dart';
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
    final chats = chatsState.chats;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Sohbetler')),
      child: HueBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(HueSpacing.md),
            child: Column(
              children: [
                HueGlassCard(
                  child: Row(
                    children: [
                      const HueLogo(size: 44),
                      const SizedBox(width: HueSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Konuşmalar',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .navTitleTextStyle
                                  .copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: HueSpacing.xxs),
                            Text(
                              '${chats.length} aktif sohbet',
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .copyWith(color: HueColors.textSecondary),
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
                          child: Text(
                            'Henüz sohbet yok.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: HueColors.textSecondary),
                          ),
                        )
                      : ListView.separated(
                          itemCount: chats.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: HueSpacing.xs),
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            final otherUser = _otherUser(repository, chat);
                            return _ChatListItem(
                              title: otherUser?.name ?? 'Bilinmiyor',
                              subtitle: chat.lastPreview ?? 'Henüz mesaj yok',
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
                            );
                          },
                        ),
                ),
                const SizedBox(height: HueSpacing.sm),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _showNewChatSheet(context, ref);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: HueSpacing.md,
                      vertical: HueSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: HueColors.blue,
                      borderRadius: BorderRadius.circular(HueRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: HueColors.blue.withValues(alpha: 0.28),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.add, color: Colors.white),
                        SizedBox(width: HueSpacing.xs),
                        Text(
                          'Yeni Sohbet Başlat',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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

  Future<void> _showNewChatSheet(BuildContext context, WidgetRef ref) async {
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
          title: const Text('Yeni Sohbet Başlat'),
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
            child: const Text('Vazgeç'),
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
      child: Container(
        padding: const EdgeInsets.all(HueSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(HueRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: HueColors.blue.withValues(alpha: 0.14),
              child: Text(
                title.characters.first.toUpperCase(),
                style: const TextStyle(
                  color: HueColors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: HueSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: HueSpacing.xxs),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: HueSpacing.sm),
            Text(
              time,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: HueColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
