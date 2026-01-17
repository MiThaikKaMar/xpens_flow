import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/domain/usecases/usecase.dart';
import 'package:xpens_flow/core/error/failures.dart';
import 'package:xpens_flow/features/transactions/domain/repositories/transaction_repository.dart';

class DeleteTransaction extends AsyncUsecase<int, int> {
  final TransactionRepository _transactionRepository;

  DeleteTransaction({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository;

  @override
  Future<Either<Failure, int>> call(int transactionId) {
    return _transactionRepository.deleteTransaction(transactionId);
  }
}
