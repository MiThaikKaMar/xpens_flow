import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/domain/usecases/usecase.dart';
import 'package:xpens_flow/core/error/failures.dart';

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction extends AsyncUsecase<void, Transaction> {
  final TransactionRepository _transactionRepository;

  AddTransaction({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository;

  @override
  Future<Either<Failure, void>> call(Transaction transaction) {
    return _transactionRepository.addTransaction(transaction);
  }
}
