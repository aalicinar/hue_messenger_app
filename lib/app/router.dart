import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_strings.dart';
import 'locale_provider.dart';
import 'theme/tokens.dart';
import '../features/chats/chats_screen.dart';
import '../features/hue_box/hue_box_screen.dart';
import '../features/settings/settings_screen.dart';

class HueRouter {
  const HueRouter._();

  static const root = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
      default:
        return CupertinoPageRoute<void>(
          builder: (_) => const AppShell(),
          settings: settings,
        );
    }
  }
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  final _pages = const [HueBoxScreen(), ChatsScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = ref.watch(localeProvider);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0C0F14).withValues(alpha: 0.82)
                  : Colors.white.withValues(alpha: 0.78),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFF6366F1).withValues(alpha: 0.08),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: HueSpacing.md,
                  vertical: HueSpacing.xs,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _TabItem(
                      icon: CupertinoIcons.square_stack_3d_up_fill,
                      inactiveIcon: CupertinoIcons.square_stack_3d_up,
                      label: S.get(lang, 'tab_hue_box'),
                      isActive: _currentIndex == 0,
                      onTap: () => _switchTab(0),
                    ),
                    _TabItem(
                      icon: CupertinoIcons.chat_bubble_2_fill,
                      inactiveIcon: CupertinoIcons.chat_bubble_2,
                      label: S.get(lang, 'tab_chats'),
                      isActive: _currentIndex == 1,
                      onTap: () => _switchTab(1),
                    ),
                    _TabItem(
                      icon: CupertinoIcons.gear_solid,
                      inactiveIcon: CupertinoIcons.gear,
                      label: S.get(lang, 'tab_settings'),
                      isActive: _currentIndex == 2,
                      onTap: () => _switchTab(2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _switchTab(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.inactiveIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData inactiveIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF6366F1);
    final inactiveColor = HueColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.12 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? icon : inactiveIcon,
                  key: ValueKey(isActive),
                  size: 24,
                  color: isActive ? activeColor : inactiveColor,
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
                letterSpacing: -0.1,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
