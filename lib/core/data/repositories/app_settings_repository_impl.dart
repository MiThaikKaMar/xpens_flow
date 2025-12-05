import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/data/datasources/hive_category_service.dart';
import 'package:xpens_flow/core/data/datasources/shared_preferences_helper.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/error/failures.dart';

import '../../common/utils/app_strings.dart';
import '../../domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final SharedPreferencesHelper prefHelper;
  final HiveCategoryService hiveService;

  AppSettingsRepositoryImpl({
    required this.prefHelper,
    required this.hiveService,
  });

  @override
  Either<Failure, String> getCurrentcurrency() {
    try {
      final currentCurrency = prefHelper.getString(
        AppStrings.sfCurrentCurrency,
      );
      return right(currentCurrency ?? '');
    } catch (e) {
      return left(DatabaseFailure(message: "GetCurrentcurrency: $e"));
    }
  }

  @override
  Either<Failure, List<CategoryModel>> getSelectedCategories() {
    try {
      final catList = hiveService.getAllCategories();
      return right(catList);
    } catch (e) {
      return left(DatabaseFailure(message: "GetSelectedCategories: $e"));
    }
  }
}
