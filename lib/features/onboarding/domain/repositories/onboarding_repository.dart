import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/error/failure.dart';
import 'package:xpens_flow/features/onboarding/data/models/category_model.dart';

abstract interface class OnboardingRepository {
  Future<Either<String, Failure>> saveSelectedCategories(
    List<CategoryModel> catList,
  );
}
