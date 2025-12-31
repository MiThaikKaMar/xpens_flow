// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

import 'package:xpens_flow/features/transactions/domain/entities/transaction_split.dart';

class Transaction {
  final int? id;
  final double amount;
  final String category;
  final TransactionType type;
  final String? merchant_note;
  final DateTime date_time;

  final String? account;
  final String? description;
  final List<String>? tags;
  final bool isTransfer;
  final bool isRecurring;
  final List<String>? attachments; // File paths/URLs
  final List<TransactionSplit>? splits;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? appliedRule;

  Transaction({
    this.id,
    required this.amount,
    required this.category,
    required this.type,
    this.merchant_note,
    required this.date_time,

    this.account,
    this.description,
    this.tags,
    this.isTransfer = false,
    this.isRecurring = false,
    this.attachments,
    this.splits,
    this.createdAt,
    this.updatedAt,
    this.appliedRule,
  });

  //Helper method to get display merchant
  String get displayMerchant => merchant_note ?? "Unknown";

  //Helper method to check if transaction has splits
  bool get hasSplits => splits != null && splits!.isNotEmpty;

  //Helper method to calculate total from splits
  double get calculatedTotal {
    if (!hasSplits) return amount;
    return splits!.fold(0.0, (sum, split) => sum + split.amount);
  }

  // Helper to validate splits sum equals transaction amount
  bool get splitsAreValid {
    if (!hasSplits) return true;
    return (calculatedTotal - amount).abs() <
        0.01; // Account for floating point
  }
}

// class Transaction {
//   final int? id;
//   final double amount;
//   final String category;
//   final TransactionType type;
//   final String? merchant_note;
//   final DateTime date_time;

//   Transaction({
//     this.id,
//     required this.amount,
//     required this.category,
//     required this.type,
//     this.merchant_note,
//     required this.date_time,
//   });
// }

enum TransactionType { income, expense, transfer }
