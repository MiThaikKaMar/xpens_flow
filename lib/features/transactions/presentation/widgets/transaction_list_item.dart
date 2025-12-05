import 'package:flutter/material.dart';
import 'package:xpens_flow/core/ui/theme/colors.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';

import '../../../../core/ui/format/date_format.dart';

class TransactionListItem extends StatefulWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.currencySymbol,
  });

  final Transaction transaction;
  final String currencySymbol;

  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  late bool _isExpense;
  late String _amountText;

  @override
  void initState() {
    super.initState();
    _isExpense = widget.transaction.type == TransactionType.expense;
    _amountText = _isExpense
        ? "-${widget.currencySymbol}${widget.transaction.amount}"
        : "+${widget.currencySymbol}${widget.transaction.amount}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      color: Colors.blue,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.transaction.merchant_note ?? '',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _amountText,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _isExpense ? AppColors.primary : AppColors.secondary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                color: Colors.green,
                child: Text(widget.transaction.category),
              ),
              Text(formatDateTime(widget.transaction.date_time)),
            ],
          ),
        ],
      ),
    );
  }
}
