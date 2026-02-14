import 'package:flutter/material.dart';
import '../theme.dart';
import 'homeease_icon.dart';

class HomeEaseSplash extends StatefulWidget {
  final VoidCallback onComplete;

  const HomeEaseSplash({super.key, required this.onComplete});

  @override
  State<HomeEaseSplash> createState() => _HomeEaseSplashState();
}

class _HomeEaseSplashState extends State<HomeEaseSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 1 second duration
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Transition after duration + brief pause
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HomeEaseIcon(size: 140),
                    SizedBox(height: 24),
                    Text(
                      "HomeEase",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Your Home, Our Priority",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.brandSlate,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
