import 'package:flutter/material.dart';

/// Defines the color palette for the application.
/// Supports both light and dark themes.
class AppColors {
  // --- Primary Accent Color (Gold/Amber) ---
  /// The main accent color used for primary actions, buttons, and highlights.
  static const Color primary = Color(0xFFFFB300); // Rich, warm gold/amber

  /// A darker shade of the primary color, used for variants or deeper accents.
  static const Color primaryVariant = Color(0xFFE69D00);

  // --- Secondary Accent Color ---
  /// A vibrant teal/cyan that complements gold and works on both themes.
  static const Color secondary = Color(0xFF00ACC1); // Vibrant cyan

  /// Darker variant of secondary color
  static const Color secondaryVariant = Color(0xFF00838F);

  // --- Dark Theme Colors ---
  /// The background color for the main screen content in dark mode.
  static const Color backgroundDark = Color(
    0xFF121212,
  ); // Standard dark background

  /// Scaffold background for dark mode (same as background)
  static const Color scaffoldBackgroundDark = Color(0xFF121212);

  /// Color for surfaces like Cards, Dialogs, and Bottom Sheets in dark mode.
  static const Color surfaceDark = Color(
    0xFF1E1E1E,
  ); // Slightly lighter than background

  /// Primary text color on dark backgrounds.
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // White

  /// Secondary text color on dark backgrounds.
  static const Color textSecondaryDark = Color(0xFFB3B3B3); // Light grey

  /// Color for disabled text or elements on dark backgrounds.
  static const Color textDisabledDark = Color(0xFF757575); // Dark grey

  // --- Light Theme Colors ---
  /// The background color for the main screen content in light mode.
  static const Color backgroundLight = Color(
    0xFFFAFAFA,
  ); // Off-white background

  /// Scaffold background for light mode
  static const Color scaffoldBackgroundLight = Color(0xFFFAFAFA);

  /// Color for surfaces like Cards, Dialogs, and Bottom Sheets in light mode.
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white

  /// Primary text color on light backgrounds.
  static const Color textPrimaryLight = Color(0xFF212121); // Almost black

  /// Secondary text color on light backgrounds.
  static const Color textSecondaryLight = Color(0xFF757575); // Medium grey

  /// Color for disabled text or elements on light backgrounds.
  static const Color textDisabledLight = Color(0xFFBDBDBD); // Light grey

  // --- Status & UI Element Colors (Work on Both Themes) ---
  /// Standard color for error messages or states.
  static const Color error = Color(0xFFCF6679); // Material error color

  /// Error color for light theme (darker, more visible)
  static const Color errorLight = Color(0xFFB00020);

  /// Success state color
  static const Color success = Color(0xFF43A047); // Green

  /// Warning state color
  static const Color warning = Color(0xFFFB8C00); // Orange

  /// Info state color
  static const Color info = Color(0xFF0288D1); // Blue

  // --- Icon Colors ---
  /// Color for accent icons (primary actions).
  static const Color iconColorAccent = primary; // Gold icons for accents

  /// Icon color for dark theme
  static const Color iconColorDark = Color(0xFFFFFFFF); // White icons

  /// Icon color for light theme
  static const Color iconColorLight = Color(0xFF212121); // Dark icons

  // --- Divider Colors ---
  /// Divider color for dark theme
  static const Color dividerDark = Color(0xFF424242);

  /// Divider color for light theme
  static const Color dividerLight = Color(0xFFE0E0E0);

  // --- Border Colors ---
  /// Border color for dark theme
  static const Color borderDark = Color(0xFF424242);

  /// Border color for light theme
  static const Color borderLight = Color(0xFFE0E0E0);

  // --- Shimmer/Loading Colors ---
  /// Base shimmer color for dark theme
  static const Color shimmerBaseDark = Color(0xFF2A2A2A);

  /// Highlight shimmer color for dark theme
  static const Color shimmerHighlightDark = Color(0xFF3A3A3A);

  /// Base shimmer color for light theme
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);

  /// Highlight shimmer color for light theme
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);
}
