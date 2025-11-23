import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/domain/repositories/app_settings_repository.dart';
import 'package:xpens_flow/core/domain/usecases/usecase.dart';
import 'package:xpens_flow/core/error/failures.dart';

class GetSelectedCategories implements Usecase<List<CategoryModel>, NoParams> {
  final AppSettingsRepository appSettingsRepository;

  GetSelectedCategories({required this.appSettingsRepository});
  @override
  Either<Failure, List<CategoryModel>> call(NoParams params) {
    return appSettingsRepository.getSelectedCategories();
  }
}
