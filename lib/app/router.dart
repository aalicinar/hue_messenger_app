import 'package:flutter/cupertino.dart';

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

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: HueColors.blue,
        inactiveColor: HueColors.textSecondary,
        backgroundColor: CupertinoDynamicColor.withBrightness(
          color: const Color(0xFFF7F8FA),
          darkColor: const Color(0xFF171A20),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_stack_3d_up),
            label: 'Hue Box',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            label: 'Sohbetler',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Ayarlar',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const CupertinoTabView(builder: _buildHueBoxTab);
          case 1:
            return const CupertinoTabView(builder: _buildChatsTab);
          default:
            return const CupertinoTabView(builder: _buildSettingsTab);
        }
      },
    );
  }
}

Widget _buildHueBoxTab(BuildContext context) => const HueBoxScreen();
Widget _buildChatsTab(BuildContext context) => const ChatsScreen();
Widget _buildSettingsTab(BuildContext context) => const SettingsScreen();
