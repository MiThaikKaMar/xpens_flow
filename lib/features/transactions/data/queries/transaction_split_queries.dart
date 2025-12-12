import 'package:sqflite/sqflite.dart';
import 'package:xpens_flow/features/transactions/data/models/transaction_split_model.dart';
import 'package:xpens_flow/features/transactions/data/tables/transaction_split_table.dart';

class TransactionSplitQueries {
  final Database db;

  TransactionSplitQueries(this.db);

  //Insert split
  Future<int> insert(TransactionSplitModel split) async {
    return await db.insert(
      TransactionSplitTable.tableName,
      split.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all splits for a transaction
  Future<List<TransactionSplitModel>> getByTransactionId(
    int transactionId,
  ) async {
    final List<Map<String, dynamic>> maps = await db.query(
      TransactionSplitTable.tableName,
      where: '${TransactionSplitTable.columnTransactionId} = ?',
      whereArgs: [transactionId],
    );

    return maps.map((map) => TransactionSplitModel.fromMap(map)).toList();
  }

  // Insert multiple splits for a transaction
  Future<void> insertMultiple(
    int transactionId,
    List<TransactionSplitModel> splits,
  ) async {
    final batch = db.batch();

    for (var split in splits) {
      final splitWithTransactionId = split.copyWith(
        transactionId: transactionId,
      );
      batch.insert(
        TransactionSplitTable.tableName,
        splitWithTransactionId.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // Delete all splits for a transaction
  Future<int> deleteByTransactionId(int transactionId) async {
    return await db.delete(
      TransactionSplitTable.tableName,
      where: '${TransactionSplitTable.columnTransactionId} =?',
      whereArgs: [transactionId],
    );
  }

  // Update Splits for a transaction (delete old, insert new)
  Future<void> updateSplits(
    int transactionId,
    List<TransactionSplitModel> splits,
  ) async {
    await deleteByTransactionId(transactionId);
    if (splits.isNotEmpty) {
      await insertMultiple(transactionId, splits);
    }
  }
}
