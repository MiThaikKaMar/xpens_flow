import 'package:flutter/material.dart';
import 'colors.dart'; // Assuming colors.dart is in the same directory

/// Defines the typographic styles for the application.
/// These styles are designed for a dark theme context.
class AppTypography {
  // --- Header Styles ---
  /// Largest headline style, suitable for prominent titles.
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark, // White for dark backgrounds
  );

  /// Medium headline style.
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
  );

  /// Small headline style.
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
  );

  // --- Body Text Styles ---
  /// Standard body text style for main content.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryDark,
  );

  /// Smaller body text, often used for secondary information.
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryDark, // Lighter grey for less emphasis
  );

  /// Smallest body text, suitable for captions or footnotes.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textDisabledDark, // Even lighter grey
  );

  // --- Label Styles ---
  /// Style for large labels, often used for buttons or active tabs.
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
  );

  /// Style for medium labels.
  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondaryDark,
  );

  // --- Special Styles for Amounts ---
  /// Large, bold style for displaying significant monetary amounts.
  static const TextStyle amountLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
  );

  /// Medium bold style for amounts.
  static const TextStyle amountMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
  );

  /// Small bold style for amounts.
  static const TextStyle amountSmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryDark,
  );
}
