import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/domain/repositories/app_settings_repository.dart';
import 'package:xpens_flow/core/domain/usecases/usecase.dart';
import 'package:xpens_flow/core/error/failures.dart';

class GetCurrentCurrency implements Usecase<String, NoParams> {
  final AppSettingsRepository appSettingsRepository;

  GetCurrentCurrency({required this.appSettingsRepository});
  @override
  Either<Failure, String> call(NoParams params) {
    return appSettingsRepository.getCurrentcurrency();
  }
}
