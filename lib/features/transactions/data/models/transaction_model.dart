// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';

import '../../domain/entities/transaction_split.dart';
import '../tables/transaction_table.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    super.id,
    required super.amount,
    required super.category,
    required super.type,
    super.merchant_note,
    required super.date_time,

    super.account,
    super.description,
    super.tags,
    super.isTransfer = false,
    super.isRecurring = false,
    super.attachments,
    super.splits,
    super.createdAt,
    super.updatedAt,
    super.appliedRule,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      TransactionTable.columnId: id,
      TransactionTable.columnAmount: amount,
      TransactionTable.columnCategory: category,
      TransactionTable.columnType: type.name,
      TransactionTable.columnMerchantNote: merchant_note,
      TransactionTable.columnDateTime: date_time.millisecondsSinceEpoch,

      // New fields
      TransactionTable.columnAccount: account,
      TransactionTable.columnDescription: description,
      TransactionTable.columnTags: tags != null ? jsonEncode(tags) : null,
      TransactionTable.columnIsTransfer: isTransfer ? 1 : 0,
      TransactionTable.columnIsRecurring: isRecurring ? 1 : 0,
      TransactionTable.columnAttachments: attachments != null
          ? jsonEncode(attachments)
          : null,
      TransactionTable.columnCreatedAt:
          createdAt?.millisecondsSinceEpoch ?? date_time.millisecondsSinceEpoch,
      TransactionTable.columnUpdatedAt:
          updatedAt?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
      TransactionTable.columnAppliedRule: appliedRule,
    };
    // Note: splits are stored in separate table, not included in main transaction map
  }

  factory TransactionModel.fromMap(
    Map<String, dynamic> map, {
    List<TransactionSplit>? splits,
  }) {
    return TransactionModel(
      id: map[TransactionTable.columnId] as int?,
      amount: (map[TransactionTable.columnAmount] as num).toDouble(),
      category: map[TransactionTable.columnCategory] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == map[TransactionTable.columnType],
      ),
      merchant_note: map[TransactionTable.columnMerchantNote] as String?,
      date_time: DateTime.fromMillisecondsSinceEpoch(
        map[TransactionTable.columnDateTime] as int,
      ),

      // New fields with null safety
      account: map[TransactionTable.columnAccount] as String?,
      description: map[TransactionTable.columnDescription] as String?,
      tags: map[TransactionTable.columnTags] != null
          ? List<String>.from(jsonDecode(map[TransactionTable.columnTags]))
          : null,
      isTransfer: (map[TransactionTable.columnIsTransfer] as int?) == 1,
      isRecurring: (map[TransactionTable.columnIsRecurring] as int?) == 1,
      attachments: map[TransactionTable.columnAttachments] != null
          ? List<String>.from(
              jsonDecode(map[TransactionTable.columnAttachments]),
            )
          : null,
      splits: splits, // Passed separately from split table query
      createdAt: map[TransactionTable.columnCreatedAt] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map[TransactionTable.columnCreatedAt] as int,
            )
          : null,
      updatedAt: map[TransactionTable.columnUpdatedAt] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map[TransactionTable.columnUpdatedAt] as int,
            )
          : null,
      appliedRule: map[TransactionTable.columnAppliedRule] as String?,
    );
  }

  // Copy with method for easy updates
  TransactionModel copyWith({
    int? id,
    double? amount,
    String? category,
    TransactionType? type,
    String? merchant_note,
    DateTime? date_time,
    String? account,
    String? description,
    List<String>? tags,
    bool? isTransfer,
    bool? isRecurring,
    List<String>? attachments,
    List<TransactionSplit>? splits,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? appliedRule,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      merchant_note: merchant_note ?? this.merchant_note,
      date_time: date_time ?? this.date_time,
      account: account ?? this.account,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isTransfer: isTransfer ?? this.isTransfer,
      isRecurring: isRecurring ?? this.isRecurring,
      attachments: attachments ?? this.attachments,
      splits: splits ?? this.splits,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      appliedRule: appliedRule ?? this.appliedRule,
    );
  }

  // Convert from Transaction entity to TransactionModel
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      category: transaction.category,
      type: transaction.type,
      merchant_note: transaction.merchant_note,
      date_time: transaction.date_time,
      account: transaction.account,
      description: transaction.description,
      tags: transaction.tags,
      isTransfer: transaction.isTransfer,
      isRecurring: transaction.isRecurring,
      attachments: transaction.attachments,
      splits: transaction.splits,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      appliedRule: transaction.appliedRule,
    );
  }
}

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       TransactionTable.columnId: id,
//       TransactionTable.columnAmount: amount,
//       TransactionTable.columnCategory: category,
//       TransactionTable.columnType: type.name,
//       TransactionTable.columnMerchantNote: merchant_note,
//       TransactionTable.columnDateTime: date_time.millisecondsSinceEpoch,

//       TransactionTable.columnAccount: account,
//       TransactionTable.columnDescription: description,
//       TransactionTable.columnTags: tags != null ? jsonEncode(tags) : null,
//       TransactionTable.columnIsTransfer: isTransfer ? 1 : 0,
//       TransactionTable.columnIsRecurring: isRecurring ? 1 : 0,
//       TransactionTable.columnAttachments: attachments != null
//           ? jsonEncode(attachments)
//           : null,
//       TransactionTable.columnCreatedAt:
//           createdAt?.millisecondsSinceEpoch ?? date_time.millisecondsSinceEpoch,
//       TransactionTable.columnUpdatedAt:
//           updatedAt?.millisecondsSinceEpoch ??
//           DateTime.now().millisecondsSinceEpoch,
//       TransactionTable.columnAppliedRule: appliedRule,
//     };
//   }

//   factory TransactionModel.fromMap(Map<String, dynamic> map) {
//     return TransactionModel(
//       id: map['id'] != null ? map['id'] as int : null,
//       amount: map['amount'] as double,
//       category: map['category'] as String,
//       type: TransactionType.values.firstWhere(
//         (e) => e.name == map['type'], //Convert string back to enum
//       ),
//       merchant_note: map['merchant_note'] != null
//           ? map['merchant_note'] as String
//           : null,
//       date_time: DateTime.fromMillisecondsSinceEpoch(map['date_time'] as int),
//     );
//   }
// }
