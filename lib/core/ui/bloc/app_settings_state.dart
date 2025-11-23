part of 'app_settings_bloc.dart';

sealed class AppSettingsState extends Equatable {
  const AppSettingsState();

  @override
  List<Object> get props => [];
}

final class AppSettingsInitial extends AppSettingsState {}

final class AppSettingsLoading extends AppSettingsState {}

final class AppSettingsLoaded extends AppSettingsState {
  final String currentCurrency;
  final List<CategoryModel> catList;

  const AppSettingsLoaded({
    required this.currentCurrency,
    required this.catList,
  });
}

final class AppSettingsError extends AppSettingsState {
  final String message;

  const AppSettingsError({required this.message});
}
