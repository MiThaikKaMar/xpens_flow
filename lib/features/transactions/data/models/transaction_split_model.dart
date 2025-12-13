import 'package:xpens_flow/features/transactions/domain/entities/transaction_split.dart';

import '../tables/transaction_split_table.dart';

class TransactionSplitModel extends TransactionSplit {
  TransactionSplitModel({
    super.id,
    super.transactionId,
    required super.category,
    required super.amount,
    super.note,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      TransactionSplitTable.columnId: id,
      TransactionSplitTable.columnTransactionId: transactionId,
      TransactionSplitTable.columnCategory: category,
      TransactionSplitTable.columnAmount: amount,
      TransactionSplitTable.columnNote: note,
    };
  }

  factory TransactionSplitModel.fromMap(Map<String, dynamic> map) {
    return TransactionSplitModel(
      id: map[TransactionSplitTable.columnId] as int?,
      transactionId: map[TransactionSplitTable.columnTransactionId] as int?,
      category: map[TransactionSplitTable.columnCategory] as String,
      amount: (map[TransactionSplitTable.columnAmount] as num).toDouble(),
      note: map[TransactionSplitTable.columnNote] as String?,
    );
  }

  // Convert from TransactionSplit entity to TransactionSplitModel
  factory TransactionSplitModel.fromEntity(TransactionSplit split) {
    return TransactionSplitModel(
      id: split.id,
      transactionId: split.transactionId,
      category: split.category,
      amount: split.amount,
      note: split.note,
    );
  }

  // Copy with method
  TransactionSplitModel copyWith({
    int? id,
    int? transactionId,
    String? category,
    double? amount,
    String? note,
  }) {
    return TransactionSplitModel(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }
}
