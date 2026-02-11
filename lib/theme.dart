import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF2D5A43);
  static const Color brandDark = Color(0xFF1A1A1A);
  static const Color brandSlate = Color(0xFF5F6368);
  static const Color brandSlateDark = Color(0xFF4A4D51);
  static const Color brandMint = Color(0xFFF4FAF7);
  static const Color scaffoldBackground = Color(0xFFF8F9FA);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        background: scaffoldBackground,
      ),
      textTheme: GoogleFonts.lexendTextTheme().apply(
        bodyColor: brandDark,
        displayColor: brandDark,
      ),
      iconTheme: const IconThemeData(
        color: brandDark,
      ),
    );
  }
}
