import 'package:flutter/material.dart';

/// Defines the color palette for the application, optimized for a dark theme.
class AppColors {
  // --- Primary Accent Color (Gold/Amber) ---
  /// The main accent color used for primary actions, buttons, and highlights.
  static const Color primary = Color(0xFFffb300); // Rich, warm gold/amber

  /// A darker shade of the primary color, used for variants or deeper accents.
  static const Color primaryVariant = Color(0xFFe69d00);

  // --- Secondary Accent Color ---
  /// A vibrant teal/cyan that complements gold and dark backgrounds.
  static const Color secondary = Color(0xFF00ACC1); // A pleasant, vibrant cyan

  // --- Dark Theme Specific Colors ---
  /// The background color for the main screen content.
  static const Color scaffoldBackgroundDark = Color(
    0xFF121212,
  ); // Standard dark theme background

  /// Color for surfaces like Cards, Dialogs, and Bottom Sheets in dark mode.
  static const Color surfaceDark = Color(
    0xFF1E1E1E,
  ); // Slightly lighter than background

  /// Primary text color on dark backgrounds.
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // White

  /// Secondary text color (e.g., subtitles, less important information) on dark backgrounds.
  static const Color textSecondaryDark = Color(0xFFB3B3B3); // Lighter grey

  /// Color for disabled text or elements on dark backgrounds.
  static const Color textDisabledDark = Color(0xFF757575); // Darker grey

  // --- Other UI Element Colors ---
  /// Standard color for error messages or states.
  static const Color error = Color(
    0xFFCF6679,
  ); // Material dark theme error color

  /// Color for accent icons (e.g., primary actions).
  static const Color iconColorAccent = primary; // Gold icons for accents
}
