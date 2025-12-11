// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

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
}

class TransactionSplit {
  final String category;
  final double amount;
  final String? note;

  TransactionSplit({required this.category, required this.amount, this.note});
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
