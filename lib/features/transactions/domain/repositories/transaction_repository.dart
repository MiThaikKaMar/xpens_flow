import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/error/failures.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';

abstract interface class TransactionRepository {
  Future<Either<Failure, void>> addTransaction(Transaction transaction);

  Future<Either<Failure, List<Transaction>>> getAllTransactions();

  Future<Either<Failure, Transaction?>> getTransactionById(int id);

  Future<Either<Failure, void>> updateTransaction(Transaction transaction);

  Future<Either<Failure, void>> deleteTransaction(int id);

  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
