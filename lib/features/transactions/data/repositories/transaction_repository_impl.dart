import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:xpens_flow/core/error/failures.dart';
import 'package:xpens_flow/features/transactions/data/models/transaction_model.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';

import 'package:xpens_flow/features/transactions/domain/repositories/transaction_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../datasources/transaction_local_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> addTransaction(Transaction transaction) async {
    try {
      // final transactionModel = TransactionModel(
      //   amount: transaction.amount,
      //   category: transaction.category,
      //   type: transaction.type,
      //   merchant_note: transaction.merchant_note,
      //   date_time: transaction.date_time,
      // );

      final transactionModel = TransactionModel.fromEntity(transaction);

      await localDataSource.insertTransaction(transactionModel);

      // final result = await getAllTransactions();
      // result.fold(
      //   (onLeft) => debugPrint(onLeft.message),
      //   (onRight) =>
      //       debugPrint("DB length: ${onRight.first.category.toString()}"),
      // );

      return Right(null);
    } on DatabaseException catch (e) {
      debugPrint(e.toString());
      return Left(DatabaseFailure(message: e.toString()));
    } catch (e) {
      debugPrint(e.toString());
      return Left(
        DatabaseFailure(message: 'Failed to add transaction: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, int>> deleteTransaction(int id) async {
    try {
      int deletedCount = await localDataSource.deleteTransaction(id);
      return Right(deletedCount);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to delete transaction: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions() async {
    try {
      debugPrint("1 ONE");
      final transactionModels = await localDataSource.getAllTransactions();
      debugPrint(transactionModels.toString());
      // Models extend entities, so they can be returned directly

      return Right(transactionModels);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Failed to get transactions: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Transaction?>> getTransactionById(int id) async {
    try {
      final transactionModel = await localDataSource.getTransactionById(id);
      return Right(transactionModel);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Failed to get transaction: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
    Transaction transaction,
  ) async {
    {
      try {
        // final transactionModel = TransactionModel(
        //   id: transaction.id,
        //   amount: transaction.amount,
        //   category: transaction.category,
        //   type: transaction.type,
        //   merchant_note: transaction.merchant_note,
        //   date_time: transaction.date_time,
        // );

        final transactionModel = TransactionModel.fromEntity(transaction);

        await localDataSource.updateTransaction(transactionModel);
        return const Right(null);
      } on DatabaseException catch (e) {
        return Left(DatabaseFailure(message: e.message));
      } catch (e) {
        return Left(
          DatabaseFailure(
            message: 'Failed to update transaction: ${e.toString()}',
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactionModels = await localDataSource
          .getTransactionsByDateRange(startDate, endDate);
      return Right(transactionModels);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Failed to get transactions: ${e.toString()}'),
      );
    }
  }
}
