import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/error/failure.dart';

abstract class Usecase<SuccessType, Params> {
  Either<SuccessType, Failure> call(Params params);
}

abstract class AsyncUsecase<SuccessType, Params> {
  Future<Either<SuccessType, Failure>> call(Params params);
}

class NoParams {}
