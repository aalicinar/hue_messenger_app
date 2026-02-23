import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme/tokens.dart';
import '../../shared/widgets/hue_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), _navigateToLogin);
  }

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF08111F), Color(0xFF0F1D33), Color(0xFF1A2942)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HueLogo(size: 132, enableAnimation: true)
                  .animate()
                  .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                  .scale(
                    begin: const Offset(0.72, 0.72),
                    end: const Offset(1.0, 1.0),
                    duration: 850.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: HueSpacing.lg),
              // ── App name ──
              Text(
                    'Hue Messenger',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    delay: 400.ms,
                    duration: 600.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
