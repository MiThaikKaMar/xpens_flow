// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

class Transaction {
  final int? id;
  final double amount;
  final String category;
  final TransactionType type;
  final String? merchant_note;
  final DateTime date_time;

  Transaction({
    this.id,
    required this.amount,
    required this.category,
    required this.type,
    this.merchant_note,
    required this.date_time,
  });
}

enum TransactionType { income, expense, transfer }
