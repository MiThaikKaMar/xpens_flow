import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/error/failures.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';

abstract interface class OnboardingRepository {
  Future<Either<Failure, String>> saveSelectedCategories(
    List<CategoryModel> catList,
  );
}
