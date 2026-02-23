import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_strings.dart';
import 'locale_provider.dart';
import 'theme/tokens.dart';
import '../features/chats/chats_screen.dart';
import '../features/hue_box/hue_box_screen.dart';
import '../features/hue_box/hue_box_controller.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';

class HueRouter {
  const HueRouter._();

  static const splash = '/splash';
  static const login = '/login';
  static const root = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (_, __, ___) => const SplashScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        );
      case login:
        return PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        );
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

    // Unacked hue message count for badge
    final hueState = ref.watch(hueBoxControllerProvider);
    final unackedCount = hueState.hueMessages.where((m) => m.isUnacked).length;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0C0F14).withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.82),
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
                  horizontal: HueSpacing.sm,
                  vertical: HueSpacing.xs + 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _TabItem(
                      icon: Icons.inbox_rounded,
                      inactiveIcon: Icons.inbox_outlined,
                      label: S.get(lang, 'tab_hue_box'),
                      isActive: _currentIndex == 0,
                      badgeCount: unackedCount,
                      onTap: () => _switchTab(0),
                    ),
                    _TabItem(
                      icon: Icons.mark_chat_unread_rounded,
                      inactiveIcon: Icons.chat_bubble_outline_rounded,
                      label: S.get(lang, 'tab_chats'),
                      isActive: _currentIndex == 1,
                      onTap: () => _switchTab(1),
                    ),
                    _TabItem(
                      icon: Icons.tune_rounded,
                      inactiveIcon: Icons.tune_rounded,
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
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData inactiveIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    const activeGradient = [Color(0xFF6366F1), Color(0xFF8B5CF6)];
    final inactiveColor = HueColors.textSecondary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HueRadius.pill),
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    activeGradient[0].withValues(alpha: isDark ? 0.2 : 0.12),
                    activeGradient[1].withValues(alpha: isDark ? 0.14 : 0.08),
                  ],
                )
              : null,
          border: isActive
              ? Border.all(
                  color: activeGradient[0].withValues(
                    alpha: isDark ? 0.25 : 0.15,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon with badge ──
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isActive ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isActive ? icon : inactiveIcon,
                      key: ValueKey(isActive),
                      size: 23,
                      color: isActive ? activeGradient[0] : inactiveColor,
                    ),
                  ),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: HueColors.red,
                        borderRadius: BorderRadius.circular(HueRadius.pill),
                        boxShadow: [
                          BoxShadow(
                            color: HueColors.red.withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(minWidth: 16),
                      child: Text(
                        badgeCount > 99 ? '99+' : '$badgeCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            // ── Label ──
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeGradient[0] : inactiveColor,
                letterSpacing: -0.1,
              ),
              child: Text(label),
            ),
            // ── Dot indicator ──
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              width: isActive ? 5 : 0,
              height: isActive ? 5 : 0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isActive
                    ? const LinearGradient(colors: activeGradient)
                    : null,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: activeGradient[0].withValues(alpha: 0.4),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
