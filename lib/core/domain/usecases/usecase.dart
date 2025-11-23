import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/error/failures.dart';

abstract class Usecase<SuccessType, Params> {
  Either<Failure, SuccessType> call(Params params);
}

abstract class AsyncUsecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
