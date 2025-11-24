// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'colors.dart'; // Assuming colors.dart is in the same directory
import 'typography.dart'; // Assuming typography.dart is in the same directory
// import 'spacing.dart'; // Assuming spacing.dart is in the same directory (if you create it)

/// Manages the application's theme data, providing both dark and light themes.
class AppTheme {
  // --- Dark Theme ---
  /// A comprehensive dark theme configuration matching the provided UI style.
  static ThemeData darkTheme = ThemeData(
    // General App Settings
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
    cardColor: AppColors.surfaceDark,
    canvasColor:
        AppColors.surfaceDark, // Background of Material components like Drawer
    // Primary and Secondary Colors
    primaryColor: AppColors.primary, // Gold accent
    primaryColorDark: AppColors.primaryVariant, // Darker gold
    secondaryHeaderColor:
        AppColors.secondary, // Used for accent colors that are not primary
    // Define the color scheme for dark mode
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary, // Gold
      primaryContainer: AppColors.primaryVariant, // Darker gold
      secondary: AppColors.secondary, // Teal/Cyan
      secondaryContainer:
          Colors.tealAccent[700]!, // A darker variant of secondary, if needed
      surface: AppColors.surfaceDark, // Dark background color
      error: AppColors.error, // Standard error color

      onPrimary:
          Colors.black, // Text color on primary color (e.g., on gold buttons)
      onSecondary: Colors.black, // Text color on secondary color
      onSurface:
          AppColors.textPrimaryDark, // Primary text color on background (white)
      onError: Colors.black, // Text color on error background
    ),

    // Text Styles - Mapping from AppTypography
    textTheme: TextTheme(
      displayLarge: AppTypography.headlineLarge,
      displayMedium: AppTypography.headlineMedium,
      displaySmall: AppTypography.headlineSmall,
      headlineLarge: AppTypography.headlineLarge,
      headlineMedium: AppTypography.headlineMedium,
      headlineSmall: AppTypography.headlineSmall,
      titleLarge: AppTypography.labelLarge, // Often used for app bar titles
      titleMedium: AppTypography.labelMedium,
      titleSmall: AppTypography.bodySmall, // For smaller titles/subtitles
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall:
          AppTypography.bodySmall, // Can be used for small button labels etc.
    ),

    // --- Component Theming for Dark Mode ---

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark, // Dark surface color for app bars
      foregroundColor: AppColors.textPrimaryDark, // White text/icons on app bar
      elevation: 0, // Flat app bars common in modern dark themes
      titleTextStyle: TextStyle(
        // Title text style for AppBar
        color: AppColors.textPrimaryDark,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, // Gold button background
        foregroundColor: Colors.black, // Dark text on gold button
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        textStyle: AppTypography.labelLarge, // Match button text style
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.primary), // Gold border
        foregroundColor: AppColors.primary, // Gold text
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary, // Gold text for text buttons
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // Input Decoration Theme (for TextFields)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark, // Dark fill for input fields
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textSecondaryDark,
      ), // Use bodyMedium but with secondary color
      labelStyle: AppTypography.bodyLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ), // Use bodyLarge but with primary color
      floatingLabelStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.primary,
      ), // Floating label color when focused
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none, // No border, rely on fill
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ), // Gold focus border
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryDark, // Default white icons
    ),
    primaryIconTheme: const IconThemeData(
      color: AppColors.iconColorAccent, // Gold icons for primary actions
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primary, // Gold selected item
      unselectedItemColor: AppColors.textSecondaryDark, // Grey unselected items
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.primary,
      ),
      unselectedLabelStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.textSecondaryDark,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedColor: AppColors.primary.withOpacity(
        0.2,
      ), // Slightly translucent gold selection
      checkmarkColor: AppColors.primary, // Gold checkmark
      labelStyle: AppTypography.bodySmall.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      secondaryLabelStyle: AppTypography.bodySmall.copyWith(
        color: AppColors.textSecondaryDark,
      ), // For unselected chips
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded chips
        side: BorderSide(
          color: AppColors.primary.withOpacity(0.5),
          width: 1,
        ), // Subtle gold border
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.black,
    ),

    // Toggleable shapes (Switches)
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary; // Gold thumb when selected
        }
        return null; // Use default thumb color when not selected
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary.withOpacity(
            0.4,
          ); // Light gold track when selected
        }
        return AppColors.textDisabledDark; // Grey track when not selected
      }),
    ),
    dialogTheme: DialogThemeData(backgroundColor: AppColors.surfaceDark),
  );

  // --- Light Theme (Basic Placeholder) ---
  // If you plan to implement a light theme later, you can define it here.
  // For now, this is a basic structure.
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary, // Still use gold as primary
    scaffoldBackgroundColor: Colors.white, // White background for light mode
    cardColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    canvasColor: Colors.white,

    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black87,
      background: Colors.white,
      onBackground: Colors.black87,
      error: AppColors.error,
      onError: Colors.white,
    ),

    textTheme: TextTheme(
      // Define light-themed text styles (e.g., black or dark grey text)
      displayLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      // ... and so on for other text styles
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 1,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Configure other components for light mode as needed
    // ...
  );
}
