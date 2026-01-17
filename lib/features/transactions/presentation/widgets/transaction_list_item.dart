// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/core/ui/theme/colors.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';
import 'package:xpens_flow/features/transactions/presentation/state/feed/transaction_feed_bloc.dart';

import '../../../../app/router/routes.dart';
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
  late Color _categoryChipColor;

  @override
  void initState() {
    super.initState();
    _isExpense = widget.transaction.type == TransactionType.expense;
  }

  @override
  Widget build(BuildContext context) {
    _amountText = _isExpense
        ? "-${widget.currencySymbol}${widget.transaction.amount}"
        : "+${widget.currencySymbol}${widget.transaction.amount}";

    _categoryChipColor = AppColors.getCategoryColor(
      widget.transaction.category,
    );

    return GestureDetector(
      onTap: () {
        final feedBloc = context.read<TransactionFeedBloc>();
        debugPrint("Transaction Detailed Id: ${widget.transaction.id}");
        context
            .push(
              //'/transactions/123',
              Routes.transactionDetail.replaceAll(
                ':id',
                widget.transaction.id.toString(),
              ),
              extra: {
                'transaction': widget.transaction,
                'symbol': widget.currencySymbol,
              },
            )
            .then((result) {
              feedBloc.add(TransactionFeedShowAll());
            });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: AppColors.borderDark.withOpacity(0.5),
              width: 0.3,
            ),
          ),
          color: AppColors.backgroundDark,
        ),
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.transaction.merchant_note ?? '-',
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
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: _categoryChipColor.withOpacity(0.1),
                    border: Border.all(
                      color: _categoryChipColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.xs),
                  ),
                  child: Text(
                    widget.transaction.category,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _categoryChipColor.withOpacity(0.8),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  formatDateForListItem(widget.transaction.date_time),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
