// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/common/utils/icon_helper.dart';
import 'package:xpens_flow/core/ui/format/date_format.dart';

import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_split.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({
    super.key,
    required this.transactionId,
    required this.transaction,
    required this.currencySymbol,
  });

  final int transactionId;
  final Transaction transaction;
  final String currencySymbol;

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late String _amountText;
  late bool _isExpense;

  @override
  void initState() {
    super.initState();
    _isExpense = widget.transaction.type == TransactionType.expense;
  }

  @override
  Widget build(BuildContext context) {
    Transaction transaction = widget.transaction;

    _amountText = _isExpense
        ? "-${widget.currencySymbol}${transaction.amount}"
        : "+${widget.currencySymbol}${transaction.amount}";

    String categoryText = transaction.category;
    String merchantNote = transaction.merchant_note ?? '';
    TransactionType type = transaction.type;
    DateTime dateTime = transaction.date_time;
    String? account = transaction.account;
    String? description = transaction.description;
    List<String>? tags = transaction.tags;
    bool isTransfer = transaction.isTransfer;
    bool isRecurring = transaction.isRecurring;
    List<String>? attachments = transaction.attachments;
    List<TransactionSplit>? splits = transaction.splits;
    DateTime? createdAt = transaction.createdAt;
    DateTime? updatedAt = transaction.updatedAt;
    String? appliedRule = transaction.appliedRule;

    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Details"),
        centerTitle: false,
        actions: [
          // Edit the transaction
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkBlueBgLight,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: IconButton(
              onPressed: () {
                context.push(
                  Routes.transactionEdit.replaceAll(
                    ':id',
                    widget.transactionId.toString(),
                  ),
                  extra: {
                    'transaction': transaction,
                    'symbol': widget.currencySymbol,
                  },
                );
              },
              icon: Icon(
                Icons.edit,
                size: AppSpacing.size18,
                color: AppColors.darkOrange.withOpacity(0.7),
              ),
              splashRadius: 1, // Minimize splash effect
              visualDensity: VisualDensity.compact, // Add this
            ),
          ),
          SizedBox(width: AppSpacing.sm),

          //Delete the transaction
          Container(
            margin: EdgeInsets.only(right: AppSpacing.md),

            decoration: BoxDecoration(
              color: AppColors.darkBlueBgLight,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete,
                size: AppSpacing.size18,
                color: AppColors.error,
              ),
              splashRadius: 1, // Minimize splash effect
              visualDensity: VisualDensity.compact, // Add this
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text("Transaction detailed ID: ${widget.transactionId}"),

            // Top part
            Text(_amountText),
            Visibility(visible: account != null, child: Text('Chase Checking')),

            /// Account
            ///Chase: This is the name of a well-known major bank (JPMorgan Chase).
            ///Checking: This indicates the type of account at Chase Bank. A checking account is a standard deposit account that allows for easy access to funds for everyday transactions like paying bills, making purchases, etc.
            ///the visual element showing "Chase Checking" below the transaction amount (-\$2,847.50) signifies that this rent payment was debited from your Chase checking account.
            Text("Posted ${formatFullDate(widget.transaction.date_time)}"),
            Divider(),

            //..................................

            /// Info Part
            ListTile(
              leading: Icon(getIconDataFromString(categoryText)),
              title: Text(categoryText),
            ),

            /// Merchant
            Visibility(
              visible: merchantNote != '',
              child: Column(children: [Text("MERCHANT"), Text(merchantNote)]),
            ),

            /// Description
            Visibility(
              visible: description != null,
              child: Column(
                children: [
                  Text("DESCRIPTION"),
                  Text("Monthly rent payment - January 2024"),
                ],
              ),
            ),

            Divider(),

            //....................................
            /// Tags
            Visibility(
              visible: tags != null,
              child: Column(
                children: [
                  Text("TAGS"),
                  ChoiceChip(label: Text("Essential"), selected: true),
                  Divider(),
                ],
              ),
            ),

            //........................................

            //Attachments
            Visibility(
              visible: attachments != null,
              child: Column(
                children: [
                  Text("ATTACHMENTS"),
                  Container(
                    color: AppColors.darkBlueBgLight,
                    width: AppSpacing.size100,
                    height: AppSpacing.size100,
                  ),
                  Divider(),
                ],
              ),
            ),

            //......................
            // Split Details
            Visibility(
              visible: splits != null && splits.isNotEmpty,
              child: Column(
                children: [
                  Text("SPLIT DETAILS"),
                  ListTile(
                    leading: Icon(Icons.house),
                    title: Text("Rent"),
                    trailing: Text("-\$2,500.00"),
                  ),
                  ListTile(
                    leading: Icon(Icons.bolt),
                    title: Text("Utilities"),
                    trailing: Text("-\$347.50"),
                  ),
                  Divider(),
                ],
              ),
            ),
            //.............................
            // Rules
            Visibility(
              visible: isTransfer,
              child: Row(
                children: [
                  Checkbox(value: true, onChanged: (bool? value) {}),
                  Text("Mark as Transfer"),
                ],
              ),
            ),
            Visibility(
              visible: isRecurring,
              child: Row(
                children: [
                  Checkbox(value: true, onChanged: (bool? value) {}),
                  Text("Recurring Transaction"),
                  Divider(),
                ],
              ),
            ),

            //................................
            //Audit
            Text("AUDIT TRAIL"),
            Text(
              "Created: ${formatFullDateTime(widget.transaction.date_time)}",
            ),
            Visibility(
              visible: updatedAt != null,
              child: Text("Updated: ${formatFullDateTime(updatedAt!)}"),
            ),
            SizedBox(height: AppSpacing.md),
            Visibility(
              visible: appliedRule != null,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Rule applied:"),
                    TextSpan(text: "Monthly Rent Auto-categorize"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
