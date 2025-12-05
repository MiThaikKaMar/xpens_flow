import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpens_flow/core/common/utils/app_strings.dart';
import 'package:xpens_flow/core/error/failures.dart';

// Not using for now.
class AppPreferencesService {
  final SharedPreferences _prefs;

  AppPreferencesService({required SharedPreferences prefs}) : _prefs = prefs;

  Future<Either<Failure, String>> getCurrencySymbol() async {
    String currencySymbolKey = AppStrings.sfCurrentCurrency;

    try {
      final String? symbol = _prefs.getString(currencySymbolKey);

      if (symbol == null || symbol.isEmpty) {
        return Left(
          PreferenceError(message: "Currency symbol not configured."),
        );
      }
      return Right(symbol);
    } catch (e) {
      debugPrint(
        "Error fetching currency symbol from SharedPreferencs:${e.toString()}",
      );
      return Left(
        PreferenceError(message: "Failed to retrieve currency symbol."),
      );
    }
  }
}
