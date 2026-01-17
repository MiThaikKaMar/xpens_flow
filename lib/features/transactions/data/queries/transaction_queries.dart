// optional complex SQL strings

import 'package:sqflite/sqflite.dart';
import 'package:xpens_flow/features/transactions/data/models/transaction_split_model.dart';
import 'package:xpens_flow/features/transactions/data/queries/transaction_split_queries.dart';
import 'package:xpens_flow/features/transactions/data/tables/transaction_table.dart';

import '../models/transaction_model.dart';

class TransactionQueries {
  final Database db;
  late final TransactionSplitQueries splitQueries;

  TransactionQueries(this.db) {
    splitQueries = TransactionSplitQueries(db);
  }

  //Insert transaction with splits
  Future<int> insert(TransactionModel transaction) async {
    final transactionId = await db.insert(
      TransactionTable.tableName,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert splits if any
    if (transaction.splits != null && transaction.splits!.isNotEmpty) {
      final splitModels = transaction.splits!
          .map((split) => TransactionSplitModel.fromEntity(split))
          .toList();

      await splitQueries.insertMultiple(transactionId, splitModels);
    }

    return transactionId;
  }

  //Get all transactions with their splits
  Future<List<TransactionModel>> getAll() async {
    final List<Map<String, dynamic>> maps = await db.query(
      TransactionTable.tableName,
      orderBy: '${TransactionTable.columnDateTime} DESC',
    );

    //Load splits for each transaction
    final transactions = <TransactionModel>[];
    for (var map in maps) {
      final transactionId = map[TransactionTable.columnId];
      final splits = await splitQueries.getByTransactionId(transactionId);
      transactions.add(TransactionModel.fromMap(map, splits: splits));
    }

    return transactions;
  }

  //Get transaction by ID with splits
  Future<TransactionModel?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      TransactionTable.tableName,
      where: '${TransactionTable.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final splits = await splitQueries.getByTransactionId(id);
    return TransactionModel.fromMap(maps.first, splits: splits);
  }

  //Update transaction with splits
  Future<int> update(TransactionModel transaction) async {
    final result = await db.update(
      TransactionTable.tableName,
      transaction.toMap(),
      where: '${TransactionTable.columnId} =?',
      whereArgs: [transaction.id],
    );

    // Update splits
    if (transaction.id != null) {
      final splitModels =
          transaction.splits
              ?.map((split) => TransactionSplitModel.fromEntity(split))
              .toList() ??
          [];
      await splitQueries.updateSplits(transaction.id!, splitModels);
    }

    return result;
  }

  //Delete transaction (splits will be detected automatically due to CASCADE)
  Future<int> delete(int id) async {
    return await db.delete(
      TransactionTable.tableName,
      where: '${TransactionTable.columnId} =?',
      whereArgs: [id],
    );
    // return deletedCount
  }

  //Get transactions by category
  Future<List<TransactionModel>> getByCategory(String category) async {
    final List<Map<String, dynamic>> maps = await db.query(
      TransactionTable.tableName,
      where: '${TransactionTable.columnCategory} = ?',
      whereArgs: [category],
      orderBy: '${TransactionTable.columnDateTime} DESC',
    );

    final transactions = <TransactionModel>[];
    for (var map in maps) {
      final transactionId = map[TransactionTable.columnId];
      final splits = await splitQueries.getByTransactionId(transactionId);
      transactions.add(TransactionModel.fromMap(map, splits: splits));
    }

    return transactions;
  }

  //Get by date range
  Future<List<TransactionModel>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final List<Map<String, dynamic>> maps = await db.query(
      TransactionTable.tableName,
      where: '${TransactionTable.columnDateTime} BETWEEN ? AND ?',
      whereArgs: [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
      orderBy: '${TransactionTable.columnDateTime} DESC',
    );

    final transactions = <TransactionModel>[];
    for (var map in maps) {
      final transactionId = map[TransactionTable.columnId];
      final splits = await splitQueries.getByTransactionId(transactionId);
      transactions.add(TransactionModel.fromMap(map, splits: splits));
    }

    return transactions;
  }
}

//   //Insert
//   Future<int> insert(TransactionModel transaction) async {
//     return await db.insert(
//       TransactionTable.tableName,
//       transaction.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   //Get all transactions
//   Future<List<TransactionModel>> getAll() async {
//     final List<Map<String, dynamic>> maps = await db.query(
//       TransactionTable.tableName,
//       orderBy: '${TransactionTable.columnDateTime} DESC',
//     );
//     //Sort the results by column_name in descending order.

//     return maps.map((map) => TransactionModel.fromMap(map)).toList();
//   }

//   //Get transaction by ID
//   Future<TransactionModel?> getById(int id) async {
//     final List<Map<String, dynamic>> maps = await db.query(
//       TransactionTable.tableName,
//       where: '${TransactionTable.columnId} = ?',
//       whereArgs: [id],
//       limit: 1,
//     );

//     if (maps.isEmpty) return null;
//     return TransactionModel.fromMap(maps.first);
//   }

//   //Update transaction
//   Future<int> update(TransactionModel transaction) async {
//     return await db.update(
//       TransactionTable.tableName,
//       transaction.toMap(),
//       where: '${TransactionTable.columnId} =?',
//       whereArgs: [transaction.id],
//     );
//   }

//   //Delete transaction
//   Future<int> delete(int id) async {
//     return await db.delete(
//       TransactionTable.tableName,
//       where: '${TransactionTable.columnId} =?',
//       whereArgs: [id],
//     );
//   }

//   //Get transactions by category
//   Future<List<TransactionModel>> getByCategory(String category) async {
//     final List<Map<String, dynamic>> maps = await db.query(
//       TransactionTable.tableName,
//       where: '${TransactionTable.columnCategory} = ?',
//       whereArgs: [category],
//       orderBy: '${TransactionTable.columnDateTime} DESC',
//     );

//     return maps.map((map) => TransactionModel.fromMap(map)).toList();
//   }

//   //Get by date range
//   Future<List<TransactionModel>> getByDateRange(
//     DateTime startDate,
//     DateTime endDate,
//   ) async {
//     final List<Map<String, dynamic>> maps = await db.query(
//       TransactionTable.tableName,
//       where: '${TransactionTable.columnDateTime} BETWEEN ? AND ?',
//       whereArgs: [
//         startDate.millisecondsSinceEpoch,
//         endDate.millisecondsSinceEpoch,
//       ],
//       orderBy: '${TransactionTable.columnDateTime} DESC',
//     );

//     return maps.map((map) => TransactionModel.fromMap(map)).toList();
//   }
// }
