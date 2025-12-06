import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/core/common/utils/app_strings.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/domain/usecases/get_current_currency.dart';
import 'package:xpens_flow/core/domain/usecases/get_selected_categories.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final GetCurrentCurrency _getCurrentCurrency;
  final GetSelectedCategories _getSelectedCategories;

  AppSettingsBloc({required getCurrentCurrency, required getSelectedCategories})
    : _getCurrentCurrency = getCurrentCurrency,
      _getSelectedCategories = getSelectedCategories,
      super(AppSettingsInitial()) {
    on<AppSettingsEvent>((_, emit) => emit(AppSettingsLoading()));
    on<LoadAppSettingsEvent>(_onLoadAppSettings);
  }

  Future<void> _onLoadAppSettings(
    LoadAppSettingsEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    String currency = '';
    List<CategoryModel> categories = [];
    bool hasError = false;
    try {
      final currencyResult = _getCurrentCurrency.appSettingsRepository
          .getCurrentcurrency();
      currencyResult.fold(
        (error) => hasError = true,
        (successCurrency) => currency = successCurrency,
      );

      final categoriesResult = _getSelectedCategories.appSettingsRepository
          .getSelectedCategories();
      categoriesResult.fold(
        (error) => hasError = true,
        (successCategories) => categories = successCategories,
      );

      if (hasError) {
        emit(AppSettingsError(message: "Failed to load some app settings!"));
        debugPrint("Failed to load some app settings!");
      } else {
        emit(AppSettingsLoaded(currentCurrency: currency, catList: categories));
      }
    } catch (e) {
      emit(
        AppSettingsError(
          message: "LoadAppSettings: ${AppStrings.unexpectedError} => $e",
        ),
      );
    }
  }
}
