import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoqoColors {
  // Light — calm sage + soft coral accent
  static const Color primaryLight = Color(0xFF3D6B5C);
  static const Color primaryVariantLight = Color(0xFF2D5246);
  static const Color secondaryLight = Color(0xFFE8A090);
  static const Color tertiaryLight = Color(0xFF7C9885);
  static const Color backgroundLight = Color(0xFFF4F6F3);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1C241F);
  static const Color textSecondaryLight = Color(0xFF5A6560);
  static const Color textTertiaryLight = Color(0xFF8A9690);
  static const Color dividerLight = Color(0xFFE2E8E4);
  static const Color successLight = Color(0xFF4A9D6E);
  static const Color warningLight = Color(0xFFE5A84A);
  static const Color errorLight = Color(0xFFD65C5C);

  // Dark — deep forest
  static const Color primaryDark = Color(0xFF8FBCA8);
  static const Color primaryVariantDark = Color(0xFF6FA388);
  static const Color secondaryDark = Color(0xFFF0B8A8);
  static const Color tertiaryDark = Color(0xFF9BB8A3);
  static const Color backgroundDark = Color(0xFF121816);
  static const Color surfaceDark = Color(0xFF1C2420);
  static const Color cardDark = Color(0xFF232E28);
  static const Color textPrimaryDark = Color(0xFFEEF2EF);
  static const Color textSecondaryDark = Color(0xFFB0BCB5);
  static const Color textTertiaryDark = Color(0xFF7A8680);
  static const Color dividerDark = Color(0xFF2D3832);
  static const Color successDark = Color(0xFF6BC48E);
  static const Color warningDark = Color(0xFFF0C06A);
  static const Color errorDark = Color(0xFFFF8080);

  // Mood colors
  static const Color moodAwful = Color(0xFFE57373);
  static const Color moodBad = Color(0xFFFFB74D);
  static const Color moodMeh = Color(0xFFFFD54F);
  static const Color moodGood = Color(0xFF81C784);
  static const Color moodGreat = Color(0xFF4ECB71);

  // Category colors
  static const Color categoryMorning = Color(0xFFE8A84A);
  static const Color categoryFocus = Color(0xFF5C8F7A);
  static const Color categoryHealth = Color(0xFF4A9D6E);
  static const Color categoryLearning = Color(0xFF5B9BD5);
  static const Color categoryEvening = Color(0xFF9B7ED9);
  static const Color categoryCustom = Color(0xFFE8A090);
}

class PoqoTheme {
  static ThemeData lightTheme() {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.light().textTheme,
    );

    const scheme = ColorScheme.light(
      primary: PoqoColors.primaryLight,
      onPrimary: Colors.white,
      secondary: PoqoColors.secondaryLight,
      onSecondary: Color(0xFF3D2A24),
      tertiary: PoqoColors.tertiaryLight,
      onTertiary: Colors.white,
      surface: PoqoColors.surfaceLight,
      onSurface: PoqoColors.textPrimaryLight,
      error: PoqoColors.errorLight,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: textTheme,
      colorScheme: scheme,
      scaffoldBackgroundColor: PoqoColors.backgroundLight,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: PoqoColors.backgroundLight,
        foregroundColor: PoqoColors.textPrimaryLight,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: PoqoColors.textPrimaryLight,
        ),
      ),
      cardTheme: CardThemeData(
        color: PoqoColors.cardLight,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PoqoColors.primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PoqoColors.primaryLight,
          side: const BorderSide(color: PoqoColors.primaryLight, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PoqoColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: PoqoColors.surfaceLight,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        surfaceTintColor: Colors.transparent,
        height: 64,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: PoqoColors.surfaceLight,
        indicatorColor: PoqoColors.primaryLight.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PoqoColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: PoqoColors.dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: PoqoColors.primaryLight, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: PoqoColors.textTertiaryLight,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PoqoColors.surfaceLight,
        selectedItemColor: PoqoColors.primaryLight,
        unselectedItemColor: PoqoColors.textTertiaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
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
        selectedColor: PoqoColors.primaryLight.withValues(alpha: 0.14),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        side: const BorderSide(color: PoqoColors.dividerLight),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData darkTheme() {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme,
    );

    const scheme = ColorScheme.dark(
      primary: PoqoColors.primaryDark,
      onPrimary: Color(0xFF0D1512),
      secondary: PoqoColors.secondaryDark,
      onSecondary: Color(0xFF2D1F1A),
      tertiary: PoqoColors.tertiaryDark,
      onTertiary: Color(0xFF0D1512),
      surface: PoqoColors.surfaceDark,
      onSurface: PoqoColors.textPrimaryDark,
      error: PoqoColors.errorDark,
      onError: Color(0xFF1A0A0A),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: textTheme,
      colorScheme: scheme,
      scaffoldBackgroundColor: PoqoColors.backgroundDark,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: PoqoColors.backgroundDark,
        foregroundColor: PoqoColors.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: PoqoColors.textPrimaryDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: PoqoColors.cardDark,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PoqoColors.primaryDark,
          foregroundColor: const Color(0xFF0D1512),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PoqoColors.primaryDark,
          side: const BorderSide(color: PoqoColors.primaryDark, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PoqoColors.primaryDark,
        foregroundColor: const Color(0xFF0D1512),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: PoqoColors.surfaceDark,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.45),
        surfaceTintColor: Colors.transparent,
        height: 64,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: PoqoColors.surfaceDark,
        indicatorColor: PoqoColors.primaryDark.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PoqoColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: PoqoColors.dividerDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: PoqoColors.primaryDark, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: PoqoColors.textTertiaryDark,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PoqoColors.surfaceDark,
        selectedItemColor: PoqoColors.primaryDark,
        unselectedItemColor: PoqoColors.textTertiaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
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
        selectedColor: PoqoColors.primaryDark.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        side: const BorderSide(color: PoqoColors.dividerDark),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
