import 'package:flutter/material.dart';
import '../theme.dart';

class AppIcon extends StatelessWidget {
  final double size;
  final bool hasShadow;

  const AppIcon({super.key, this.size = 124, this.hasShadow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.forestGreen,
            Color(0xFF2D9CDB), // Teal-ish secondary
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppTheme.forestGreen.withOpacity(0.3),
                  blurRadius: size * 0.2,
                  offset: Offset(0, size * 0.1),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // House symbol
            Icon(Icons.home_rounded, size: size * 0.6, color: Colors.white),
            // Subtle accent (tool or sparkle)
            Positioned(
              right: size * 0.15,
              bottom: size * 0.15,
              child: Container(
                padding: EdgeInsets.all(size * 0.05),
                decoration: const BoxDecoration(
                  color: Color(0xFFF2C94C), // Yellow accent
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: size * 0.15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
