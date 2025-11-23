import 'package:xpens_flow/features/transactions/data/models/transaction_model.dart';

abstract interface class TransactionLocalDataSource {
  Future<int> insertTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel?> getTransactionById(int id);
  Future<int> updateTransaction(TransactionModel transaction);
  Future<int> deleteTransaction(int id);
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
