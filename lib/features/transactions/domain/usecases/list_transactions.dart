import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/domain/usecases/usecase.dart';
import 'package:xpens_flow/core/error/failures.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';
import 'package:xpens_flow/features/transactions/domain/repositories/transaction_repository.dart';

class ListTransactions extends AsyncUsecase<List<Transaction>, NoParams> {
  final TransactionRepository _transactionRepository;

  ListTransactions({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository;

  @override
  Future<Either<Failure, List<Transaction>>> call(NoParams? params) {
    return _transactionRepository.getAllTransactions();
  }
}
