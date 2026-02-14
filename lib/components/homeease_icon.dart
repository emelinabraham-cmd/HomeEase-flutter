import 'package:flutter/material.dart';
import '../theme.dart';

class HomeEaseIcon extends StatelessWidget {
  final double size;
  final bool hasShadow;

  const HomeEaseIcon({super.key, this.size = 124, this.hasShadow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.forestGreen, AppTheme.primary],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppTheme.forestGreen.withOpacity(0.3),
                  blurRadius: size * 0.15,
                  offset: Offset(0, size * 0.08),
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // House Base
            Icon(Icons.home_rounded, size: size * 0.6, color: Colors.white),
            // Tool Overlay
            Positioned(
              right: size * 0.18,
              bottom: size * 0.18,
              child: Container(
                padding: EdgeInsets.all(size * 0.04),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF2C94C,
                  ), // Gold accent for "Quality/Pro"
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.forestGreen,
                    width: size * 0.02,
                  ),
                ),
                child: Icon(
                  Icons.build_rounded,
                  size: size * 0.15,
                  color: AppTheme.forestGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
