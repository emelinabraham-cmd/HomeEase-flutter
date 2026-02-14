import 'package:flutter/material.dart';
import '../theme.dart';
import '../components/app_icon.dart';

class AppSplash extends StatefulWidget {
  final VoidCallback onComplete;

  const AppSplash({super.key, required this.onComplete});

  @override
  State<AppSplash> createState() => _AppSplashState();
}

class _AppSplashState extends State<AppSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Transition after duration
    Future.delayed(const Duration(milliseconds: 2000), () {
      widget.onComplete();
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
                    AppIcon(size: 140),
                    SizedBox(height: 32),
                    Text(
                      "HomeEase",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandDark,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "பணி எளிது, வாழ்க்கை இனிது",
                      style: TextStyle(
                        fontSize: 14,
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
