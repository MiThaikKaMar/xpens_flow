import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';

import '../../error/failures.dart';

abstract interface class AppSettingsRepository {
  Either<Failure, String> getCurrentcurrency();

  Either<Failure, List<CategoryModel>> getSelectedCategories();
}
