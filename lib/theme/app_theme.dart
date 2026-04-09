import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoqoColors {
  // Light theme
  static const Color primaryLight = Color(0xFF6B73FF);
  static const Color primaryVariantLight = Color(0xFF5A62E3);
  static const Color secondaryLight = Color(0xFFFF9A76);
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1D3E);
  static const Color textSecondaryLight = Color(0xFF6E7191);
  static const Color textTertiaryLight = Color(0xFFA0A3BD);
  static const Color dividerLight = Color(0xFFEFF0F6);
  static const Color successLight = Color(0xFF4ECB71);
  static const Color warningLight = Color(0xFFFFB547);
  static const Color errorLight = Color(0xFFFF6B6B);

  // Dark theme
  static const Color primaryDark = Color(0xFF8B92FF);
  static const Color primaryVariantDark = Color(0xFF7A82F0);
  static const Color secondaryDark = Color(0xFFFFAD8E);
  static const Color backgroundDark = Color(0xFF0F1023);
  static const Color surfaceDark = Color(0xFF1A1B30);
  static const Color cardDark = Color(0xFF222340);
  static const Color textPrimaryDark = Color(0xFFEEEFF5);
  static const Color textSecondaryDark = Color(0xFFA0A3BD);
  static const Color textTertiaryDark = Color(0xFF6E7191);
  static const Color dividerDark = Color(0xFF2D2E48);
  static const Color successDark = Color(0xFF5DD87E);
  static const Color warningDark = Color(0xFFFFBF5C);
  static const Color errorDark = Color(0xFFFF7B7B);

  // Mood colors
  static const Color moodAwful = Color(0xFFE57373);
  static const Color moodBad = Color(0xFFFFB74D);
  static const Color moodMeh = Color(0xFFFFD54F);
  static const Color moodGood = Color(0xFF81C784);
  static const Color moodGreat = Color(0xFF4ECB71);

  // Category colors
  static const Color categoryMorning = Color(0xFFFFB547);
  static const Color categoryFocus = Color(0xFF6B73FF);
  static const Color categoryHealth = Color(0xFF4ECB71);
  static const Color categoryLearning = Color(0xFF29B6F6);
  static const Color categoryEvening = Color(0xFF7E57C2);
  static const Color categoryCustom = Color(0xFFFF9A76);
}

class PoqoTheme {
  static ThemeData lightTheme() {
    final textTheme = GoogleFonts.nunitoTextTheme(
      ThemeData.light().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: PoqoColors.primaryLight,
        secondary: PoqoColors.secondaryLight,
        surface: PoqoColors.surfaceLight,
        error: PoqoColors.errorLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: PoqoColors.textPrimaryLight,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: PoqoColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: PoqoColors.backgroundLight,
        foregroundColor: PoqoColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: PoqoColors.textPrimaryLight,
        ),
      ),
      cardTheme: CardThemeData(
        color: PoqoColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PoqoColors.primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PoqoColors.primaryLight,
          side: const BorderSide(color: PoqoColors.primaryLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PoqoColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PoqoColors.dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: PoqoColors.primaryLight, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.nunito(
          color: PoqoColors.textTertiaryLight,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PoqoColors.surfaceLight,
        selectedItemColor: PoqoColors.primaryLight,
        unselectedItemColor: PoqoColors.textTertiaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: PoqoColors.dividerLight,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: PoqoColors.backgroundLight,
        selectedColor: PoqoColors.primaryLight.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(color: PoqoColors.dividerLight),
      ),
    );
  }

  static ThemeData darkTheme() {
    final textTheme = GoogleFonts.nunitoTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: PoqoColors.primaryDark,
        secondary: PoqoColors.secondaryDark,
        surface: PoqoColors.surfaceDark,
        error: PoqoColors.errorDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: PoqoColors.textPrimaryDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: PoqoColors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: PoqoColors.backgroundDark,
        foregroundColor: PoqoColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: PoqoColors.textPrimaryDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: PoqoColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PoqoColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PoqoColors.primaryDark,
          side: const BorderSide(color: PoqoColors.primaryDark),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PoqoColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: PoqoColors.dividerDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: PoqoColors.primaryDark, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.nunito(
          color: PoqoColors.textTertiaryDark,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PoqoColors.surfaceDark,
        selectedItemColor: PoqoColors.primaryDark,
        unselectedItemColor: PoqoColors.textTertiaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: PoqoColors.dividerDark,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: PoqoColors.surfaceDark,
        selectedColor: PoqoColors.primaryDark.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(color: PoqoColors.dividerDark),
      ),
    );
  }
}
