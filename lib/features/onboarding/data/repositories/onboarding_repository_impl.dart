import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/features/onboarding/data/hive/hive_category_service.dart';
import 'package:xpens_flow/core/error/failure.dart';
import 'package:xpens_flow/features/onboarding/data/models/category_model.dart';
import 'package:xpens_flow/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._hiveCategoryService);

  final HiveCategoryService _hiveCategoryService;

  @override
  Future<Either<String, Failure>> saveSelectedCategories(
    List<CategoryModel> catList,
  ) async {
    try {
      await _hiveCategoryService.clearAll();
      for (var cat in catList) {
        await _hiveCategoryService.addCategory(cat);
      }

      return left("Added selected categories success!");
    } catch (e) {
      return right(Failure(e.toString()));
    }
  }
}
