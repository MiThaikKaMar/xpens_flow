// ignore_for_file: non_constant_identifier_names

import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    super.id,
    required super.amount,
    required super.category,
    required super.type,
    super.merchant_note,
    required super.date_time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'category': category,
      'type': type.name,
      'merchant_note': merchant_note,
      'date_time': date_time.millisecondsSinceEpoch,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] != null ? map['id'] as int : null,
      amount: map['amount'] as double,
      category: map['category'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'], //Convert string back to enum
      ),
      merchant_note: map['merchant_note'] != null
          ? map['merchant_note'] as String
          : null,
      date_time: DateTime.fromMillisecondsSinceEpoch(map['date_time'] as int),
    );
  }
}
