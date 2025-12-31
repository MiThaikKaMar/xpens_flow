// ignore_for_file: public_member_api_docs, sort_constructors_first

class TransactionSplit {
  final String id;
  final int? transactionId; //Foreign key to parent transaction
  final String category;
  final double amount;
  final String? note;

  TransactionSplit({
    required this.id,
    this.transactionId,
    required this.category,
    required this.amount,
    this.note,
  });

  // Helper to check if split is valid
  bool get isValid => amount > 0 && category.isNotEmpty;
}
