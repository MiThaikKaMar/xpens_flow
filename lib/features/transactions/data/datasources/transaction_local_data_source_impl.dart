import 'package:xpens_flow/core/data/datasources/database_helper.dart';
import 'package:xpens_flow/core/error/exceptions.dart';
import 'package:xpens_flow/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:xpens_flow/features/transactions/data/models/transaction_model.dart';
import 'package:xpens_flow/features/transactions/data/queries/transaction_queries.dart';

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final DatabaseHelper databaseHelper;

  TransactionLocalDataSourceImpl({required this.databaseHelper});

  Future<T> _executeQuery<T>(
    Future<T> Function(TransactionQueries queries) queryFunction,
  ) async {
    try {
      final db = await databaseHelper.database;
      final queries = TransactionQueries(db);
      return await queryFunction(queries);
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to execute database operation: ${e.toString()}',
      );
    }
  }

  @override
  Future<int> deleteTransaction(int id) {
    return _executeQuery((queries) => queries.delete(id));
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return _executeQuery((queries) => queries.getAll());
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _executeQuery(
      (queries) => queries.getByDateRange(startDate, endDate),
    );
  }

  @override
  Future<TransactionModel?> getTransactionById(int id) {
    return _executeQuery((queries) => queries.getById(id));
  }

  @override
  Future<int> insertTransaction(TransactionModel transaction) async {
    return _executeQuery((queries) => queries.insert(transaction));
  }

  @override
  Future<int> updateTransaction(TransactionModel transaction) {
    return _executeQuery((queries) => queries.update(transaction));
  }
}
