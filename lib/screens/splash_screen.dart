import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: Center(
        child: Image.asset(
          'icon.png',
          width: 200,
          height: 200,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.spa, size: 100, color: Colors.white),
        )
        .animate()
        .fade(duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack)
        .shimmer(delay: 1.seconds, duration: 1.5.seconds, color: Colors.white24),
      ),
    );
  }
}
