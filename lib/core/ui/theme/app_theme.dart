// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'colors.dart';
import 'typography.dart';

/// Manages the application's theme data, providing both dark and light themes.
class AppTheme {
  // Shade Styles
  static RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
    side: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.circular(AppSpacing.sm),
  );

  // === DARK THEME ===
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Scaffold & Canvas
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
    canvasColor: AppColors.surfaceDark,
    cardColor: AppColors.surfaceDark,

    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryVariant,
      surface: AppColors.surfaceDark,
      background: AppColors.backgroundDark,
      error: AppColors.error,

      // Text on colors
      onPrimary: Colors.black, // Black text on gold
      onSecondary: Colors.black,
      onSurface: AppColors.textPrimaryDark,
      onBackground: AppColors.textPrimaryDark,
      onError: Colors.white,
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTypography.headlineLarge,
      displayMedium: AppTypography.headlineMedium,
      displaySmall: AppTypography.headlineSmall,
      headlineLarge: AppTypography.headlineLarge,
      headlineMedium: AppTypography.headlineMedium,
      headlineSmall: AppTypography.headlineSmall,
      titleLarge: AppTypography.labelLarge,
      titleMedium: AppTypography.labelMedium,
      titleSmall: AppTypography.bodySmall,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.bodySmall,
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      // backgroundColor: AppColors.surfaceDark,
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.headlineSmall.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      iconTheme: IconThemeData(color: AppColors.iconColorDark),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        elevation: 4,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary, width: 2),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,

      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textSecondaryDark,
      ),
      labelStyle: AppTypography.bodyLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      floatingLabelStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.primary,
      ),

      // Borders
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(color: AppColors.iconColorDark),
    primaryIconTheme: IconThemeData(color: AppColors.iconColorAccent),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: AppTypography.labelMedium,
      unselectedLabelStyle: AppTypography.labelMedium,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedColor: AppColors.primary.withOpacity(0.2),
      disabledColor: AppColors.textDisabledDark,
      checkmarkColor: AppColors.primary,
      labelStyle: AppTypography.bodySmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
      ),
    ),

    // FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.black,
      elevation: 6,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.textDisabledDark;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary.withOpacity(0.4);
        }
        return AppColors.borderDark;
      }),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Divider
    dividerColor: AppColors.dividerDark,
    dividerTheme: DividerThemeData(color: AppColors.dividerDark, thickness: 1),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  // === LIGHT THEME ===
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Scaffold & Canvas
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundLight,
    canvasColor: AppColors.surfaceLight,
    cardColor: AppColors.surfaceLight,

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryVariant,
      surface: AppColors.surfaceLight,
      background: AppColors.backgroundLight,
      error: AppColors.errorLight,

      // Text on colors
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppColors.textPrimaryLight,
      onBackground: AppColors.textPrimaryLight,
      onError: Colors.white,
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      displayMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      displaySmall: AppTypography.headlineSmall.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      headlineSmall: AppTypography.headlineSmall.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      titleLarge: AppTypography.labelLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      titleMedium: AppTypography.labelMedium.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodyLarge: AppTypography.bodyLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: AppColors.textSecondaryLight,
      ),
      bodySmall: AppTypography.bodySmall.copyWith(
        color: AppColors.textDisabledLight,
      ),
      labelLarge: AppTypography.labelLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      labelMedium: AppTypography.labelMedium.copyWith(
        color: AppColors.textSecondaryLight,
      ),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimaryLight,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: AppTypography.headlineSmall.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      iconTheme: IconThemeData(color: AppColors.iconColorLight),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary, width: 2),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,

      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textSecondaryLight,
      ),
      labelStyle: AppTypography.bodyLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      floatingLabelStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.primary,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.errorLight, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.errorLight, width: 2),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(color: AppColors.iconColorLight),
    primaryIconTheme: IconThemeData(color: AppColors.iconColorAccent),

    // Card
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: AppTypography.labelMedium,
      unselectedLabelStyle: AppTypography.labelMedium,
    ),

    // Divider
    dividerColor: AppColors.dividerLight,
    dividerTheme: DividerThemeData(color: AppColors.dividerLight, thickness: 1),
  );
}
