import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _primaryDark = Color(0xFF6C63FF);
  static const Color _secondaryDark = Color(0xFF03DAC6);
  static const Color _backgroundDark = Color(0xFF0D0D1A);
  static const Color _surfaceDark = Color(0xFF1A1A2E);
  static const Color _cardDark = Color(0xFF16213E);

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: _primaryDark,
        secondary: _secondaryDark,
        surface: _surfaceDark,
        error: Color(0xFFCF6679),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Color(0xFFE2E2E2),
      ),
      scaffoldBackgroundColor: _backgroundDark,
      textTheme: GoogleFonts.interTextTheme(
        base.textTheme,
      ).apply(bodyColor: const Color(0xFFE2E2E2), displayColor: Colors.white),
      cardTheme: CardThemeData(
        color: _cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2A2A4A), width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _backgroundDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2A2A4A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2A2A4A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFCF6679)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF9E9EB8)),
        hintStyle: const TextStyle(color: Color(0xFF5A5A7A)),
        prefixIconColor: const Color(0xFF9E9EB8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryDark,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryDark,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: CircleBorder(),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceDark,
        selectedColor: _primaryDark,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: Color(0xFF2A2A4A)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2A4A),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _cardDark,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceDark,
        selectedItemColor: _primaryDark,
        unselectedItemColor: Color(0xFF5A5A7A),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 24,
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF5B52E0),
        secondary: Color(0xFF00B8A9),
        surface: Color(0xFFF5F5FF),
        error: Color(0xFFB00020),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1A1A2E),
      ),
      scaffoldBackgroundColor: const Color(0xFFF0F0FA),
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE0E0F5), width: 1),
        ),
      ),
    );
  }
}

class CategoryColors {
  static const Map<String, Color> _colors = {
    'Food & Dining': Color(0xFFFF6B6B),
    'Transport': Color(0xFF4ECDC4),
    'Shopping': Color(0xFFFFE66D),
    'Entertainment': Color(0xFFA29BFE),
    'Health': Color(0xFF6BCB77),
    'Utilities': Color(0xFFFF9F43),
    'Education': Color(0xFF54A0FF),
    'Travel': Color(0xFFFF6BA8),
    'Rent & Housing': Color(0xFFBDC3C7),
    'Savings': Color(0xFF00D2D3),
    'Others': Color(0xFF9E9EB8),
  };

  static const List<String> categories = [
    'Food & Dining',
    'Transport',
    'Shopping',
    'Entertainment',
    'Health',
    'Utilities',
    'Education',
    'Travel',
    'Rent & Housing',
    'Savings',
    'Others',
  ];

  static Color forCategory(String category) {
    return _colors[category] ?? const Color(0xFF9E9EB8);
  }

  static Color forIndex(int index) {
    final values = _colors.values.toList();
    return values[index % values.length];
  }
}
