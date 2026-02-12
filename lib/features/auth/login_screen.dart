import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_strings.dart';
import '../../app/locale_provider.dart';
import '../../app/theme/tokens.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isRegister = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _login() {
    // Mock login — just navigate to the main app
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: HueSpacing.lg),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: HueSpacing.xxl),

                  // ── Logo ──
                  ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/icons/hue_logo_gradient.png',
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      ),

                  const SizedBox(height: HueSpacing.md),

                  // ── Title ──
                  Text(
                    'Hue Messenger',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 500.ms),

                  const SizedBox(height: 6),

                  Text(
                    'Feel your messages',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ).animate(delay: 400.ms).fadeIn(duration: 500.ms),

                  const SizedBox(height: HueSpacing.xxl),

                  // ── Glass Card ──
                  ClipRRect(
                        borderRadius: BorderRadius.circular(HueRadius.xl),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(HueSpacing.lg),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(HueRadius.xl),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // ── Toggle ──
                                Row(
                                  children: [
                                    _TabToggle(
                                      label: S.get(lang, 'login_tab_login'),
                                      isActive: !_isRegister,
                                      onTap: () =>
                                          setState(() => _isRegister = false),
                                    ),
                                    const SizedBox(width: HueSpacing.xs),
                                    _TabToggle(
                                      label: S.get(lang, 'login_tab_register'),
                                      isActive: _isRegister,
                                      onTap: () =>
                                          setState(() => _isRegister = true),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: HueSpacing.lg),

                                // ── Phone input ──
                                CupertinoTextField(
                                  controller: _phoneController,
                                  placeholder: S.get(lang, 'login_phone_hint'),
                                  keyboardType: TextInputType.phone,
                                  prefix: Padding(
                                    padding: const EdgeInsets.only(
                                      left: HueSpacing.sm,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.phone,
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      size: 20,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: HueSpacing.sm,
                                    vertical: HueSpacing.md,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(
                                      HueRadius.md,
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  placeholderStyle: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    fontSize: 16,
                                  ),
                                ),

                                if (_isRegister) ...[
                                  const SizedBox(height: HueSpacing.sm),
                                  // ── Name input for register ──
                                  CupertinoTextField(
                                    placeholder: S.get(lang, 'login_name_hint'),
                                    prefix: Padding(
                                      padding: const EdgeInsets.only(
                                        left: HueSpacing.sm,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.person,
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        size: 20,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: HueSpacing.sm,
                                      vertical: HueSpacing.md,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.06,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        HueRadius.md,
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    placeholderStyle: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.35,
                                      ),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],

                                const SizedBox(height: HueSpacing.lg),

                                // ── Submit button ──
                                GestureDetector(
                                  onTap: _login,
                                  child: Container(
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        HueRadius.md,
                                      ),
                                      gradient: const LinearGradient(
                                        colors: HueColors.accentGradient,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF6366F1,
                                          ).withValues(alpha: 0.4),
                                          blurRadius: 20,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        _isRegister
                                            ? S.get(lang, 'login_register_btn')
                                            : S.get(lang, 'login_login_btn'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(
                        begin: 0.15,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: HueSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabToggle extends StatelessWidget {
  const _TabToggle({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: HueSpacing.sm),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(HueRadius.sm),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.45),
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
