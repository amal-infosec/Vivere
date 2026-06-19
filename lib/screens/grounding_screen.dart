import 'package:flutter/material.dart';

class GroundingScreen extends StatefulWidget {
  const GroundingScreen({super.key});

  @override
  State<GroundingScreen> createState() => _GroundingScreenState();
}

class _GroundingScreenState extends State<GroundingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        title: const Text('Take a Breath'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          Theme.of(context).colorScheme.primary.withOpacity(0.0),
                        ],
                      ),
                      boxShadow: [
                         BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 40, spreadRadius: 10)
                      ]
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 120),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                bool isBreatheIn = _controller.status == AnimationStatus.forward;
                return Text(
                  isBreatheIn ? "Breathe In..." : "Breathe Out...",
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w300, color: Colors.white70, letterSpacing: 2),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "You are safe here. This will pass.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.4), fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
